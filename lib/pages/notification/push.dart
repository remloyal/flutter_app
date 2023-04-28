// websockt及友盟推送
import 'dart:convert';

import 'package:fire_control_app/common/constants.dart';
import 'package:fire_control_app/common/fc_icon.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/common/log.dart';
import 'package:fire_control_app/http/push_api.dart';
import 'package:fire_control_app/models/notification.dart';
import 'package:fire_control_app/models/profile.dart';
import 'package:fire_control_app/pages/alarm/details/alarm_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/danger_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/fault_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/fire_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/trouble_detail_page.dart';
import 'package:fire_control_app/states/notify_message_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

class NotifyCenter extends StatefulWidget {

  NotifyCenterController controller;

  NotifyCenter({required this.controller});


  @override
  State<StatefulWidget> createState() => _NotifyCenterState();
}

class _NotifyCenterState extends State<NotifyCenter> {

  @override
  Widget build(BuildContext context) {
    var of = Provider.of<NotifyMessageModel>(context);

    List<Widget> children = [];

    if (of.currentMessage != null) {
      children.add(_buildBanner(of.currentMessage!));
    }

    if (of.nextMessage != null) {
      children.add(_buildBanner(of.nextMessage!));
    }

    if (of.remainCount > 0) {
      children.add(_buildFooter(of.remainCount));
    }

    if (children.isEmpty) return Container();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildBanner(NotifyMessage message) {
    BannerConfig? config = notificationTypes[message.type];
    if (config == null) return Container();
    return GestureDetector(
      onTap: () {
        String routeName = '';
        switch (config!.type) {
          case BannerType.fire:
            routeName = FireDetailPage.routeName;
            break;
          case BannerType.none:
            break;
          case BannerType.alarm:
            routeName = AlarmDetailPage.routeName;
            break;
          case BannerType.fault:
            routeName = FaultDetailPage.routeName;
            break;
          case BannerType.trouble:
            routeName = TroubleDetailPage.routeName;
            break;
          case BannerType.danger:
            routeName = DangerDetailPage.routeName;
            break;
        }

        if (routeName.isNotEmpty) {
          Navigator.pushNamed(context, DangerDetailPage.routeName, arguments: message.referenceId);
        }
      },
      child: Container(
        color: config!.bgColor,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                config!.icon,
                SizedBox(width: 5,),
                Expanded(child: Text(config!.name)),
                Text(message.time),
                SizedBox(width: 5,),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    widget.controller.closeMessage(message);
                  },)
              ],
            ),
            Container(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Text(message.title), flex: 1,),
                  Icon(FcmIcon.rightArrow)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(int count) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                color: Color(0xffeceff1)
            ),
            child: Center(child: Text("还剩$count条通知", style: TextStyle(color: Color(0xff607d8b)),),),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              widget.controller.closeNotifyCenter();
            },
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                  color: Color(0xff455A64)
              ),
              child:  const Center(child: Text("清除消息", style: TextStyle(color: Color(0xffeceff1)))),
            ),
          ),
        ),
      ],
    );
  }
}

class NotifyCenterController {

  // 待播报的信息
  final List<NotifyMessage> _remainMessages = [];

  // 正在播报的信息
  late NotifyMessage _playingMessage;

  OverlaySupportEntry? _entry;

  AudioPlayer? _player;

  static const int _retry = 2;

  String token = "";

  NotifyMessageModel _getModel() {
    var context = Global.navigatorKey!.currentContext;
    return Provider.of<NotifyMessageModel>(context!, listen: false);
  }

  void processMessage(NotifyMessage message) {
    NotifyMessageModel model = _getModel();
    if (model.currentMessage == null) {
      model.currentMessage = message;
      _showNotifyCenter();
      _playAudio(message);
    } else if (model.nextMessage == null) {
      model.nextMessage = message;
    } else {
      _remainMessages.add(message);
      model.remainCount = _remainMessages.length;
    }
  }

  void _playAudio(NotifyMessage? message) {
    if (message == null) return;
    _player?.stop();
    _playingMessage = message;
    _play(Uri.encodeComponent(message.title), 0);
  }

  Future<void> _play(String text, int num) async {
    List<String> results = [
      "tex=$text",
      "tok=$token",
      "spd=5",
      "pit=5",
      "vol=15",
      "per=0",
      "cuid=$token",
      "ctp=1",
      "lan=zh",
      "aue=3",
    ];
    String param = results.join("&");

    String url = 'https://tsn.baidu.com/text2audio?$param';

    try {
      await _player?.setUrl(url);
      _player?.play();
    } catch (e) {
      // Fallback for all other errors
      // print('An error occured: $e');
      PushApi.getBaiduToken().then((data) {
        token = data;
        if (num < _retry) {
          _play(text, ++num);
        }
      });
    }
  }

  void _showNotifyCenter() {
    _entry ??= showSimpleNotification(NotifyCenter(controller: this), autoDismiss: false, contentPadding: EdgeInsets.zero, background: Colors.transparent);
    _player ??= AudioPlayer();
    _player?.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        // print("播放完成");
        closeMessage(_playingMessage);
      }
    });
  }

  void closeMessage(NotifyMessage message) {
    NotifyMessageModel model = _getModel();
    if (model.currentMessage == message) {
      if (model.nextMessage == null) {
        closeNotifyCenter();
      } else {
        model.currentMessage = model.nextMessage;
        _playAudio(model.currentMessage);
        _setNextMessage(model);
      }
    } else if (model.nextMessage == message) {
      _setNextMessage(model);
    }
  }

  void _setNextMessage(NotifyMessageModel model) {
    model.nextMessage = _remainMessages.isNotEmpty ? _remainMessages.removeAt(0) : null;
    model.remainCount = _remainMessages.length;
  }

  void closeNotifyCenter() {
    _entry?.dismiss();
    _entry = null;

    NotifyMessageModel model = _getModel();
    model.clear();

    _player?.stop();
    _player?.dispose();
    _player = null;
  }

}

class PushHelper {

  static final NotifyCenterController _controller = NotifyCenterController();

  static void initNotify() {
    initUMengPush();
    initWebSocket();
  }

  static void initUMengPush() async {
    if (!Global.isRelease) {
      // UmengPushSdk.setLogEnable(true);
    }

    final Profile profile = Global.profile;
    // 未同意用户协议
    if (!profile.isAgree) return;
    // 未登录
    if (!profile.isLogin) return;

    await UmengPushSdk.register("5eb661d4167edd40ea0001ee", "AppStore");

    String? deviceToken = await UmengPushSdk.getRegisteredId();
    if (deviceToken == null) {
      Log.error("友盟推送>>>注册失败!");
    } else {
      Log.info("友盟推送>>>注册成功！deviceToken: $deviceToken");
    }

    bool? isAddSuccess = await UmengPushSdk.setAlias(
        "${profile.userId}_${profile.apiInfo.appKey}", profile.apiInfo.appKey);
    if (isAddSuccess == null || !isAddSuccess) {
      Log.error("友盟推送>>>注册别名失败！");
    }

    //透传消息回调
    UmengPushSdk.setMessageCallback((result) {
      Log.info("友盟推送>>>收到透传消息: $result}");
    });

    // 通知消息回调（到达：receive，点击：open）
    UmengPushSdk.setNotificationCallback((receive) {
      Log.info("友盟推送>>>收到通知消息: $receive}");
    }, (open) {
      Log.info("友盟推送>>>打开通知消息: $open");
    });
  }

  static void removeUMengPush() async {
    bool? isRemoveSuccess = await UmengPushSdk.removeAlias(
        "${Global.profile.userId}_${Global.profile.apiInfo.appKey}",
        Global.profile.apiInfo.appKey);
  }

  static late StompClient client;

  static void initWebSocket() {
    client = StompClient(
        config: StompConfig.SockJS(
          url:
          '${Global.profile.apiInfo.baseUrl}/socket?ticket=${Global.profile.apiInfo.ticket}',
          webSocketConnectHeaders: {'user-agent': Constants.userAgent},
          onDebugMessage: (String msg) {
            // Log.debug(msg);
          },
          onConnect: _onConnect,
        ));

    client.activate();
  }

  static void _onConnect(_) {
    Log.info("websocket>>>连接成功");

    //广播消息
    client.subscribe(
        destination: '/topic/broadcast', callback: (StompFrame frame) {});

    //点对点
    client.subscribe(
      destination: '/user/topic/p2p',
      callback: (StompFrame frame) {
        Log.info("websocket>>>收到消息：${frame.body}");
        Map<String, dynamic> body = jsonDecode(frame.body ?? '{}');
        if (body['data'] != null && body['data']['opt'] != null) {
          NotifyMessage message = NotifyMessage.fromJson(body['data']['opt']);
          _controller.processMessage(message);
        }
      });
  }
}
