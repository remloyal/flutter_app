// websockt及友盟推送
import 'dart:convert';

import 'package:fire_control_app/common/constants.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/common/log.dart';
import 'package:fire_control_app/http/push_api.dart';
import 'package:fire_control_app/models/notification.dart';
import 'package:fire_control_app/models/profile.dart';
import 'package:fire_control_app/pages/alarm/details/alarm_fault_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/danger_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/fire_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/trouble_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

class NotifyCenter extends StatefulWidget {

  final NotifyCenterController controller;

  const NotifyCenter({super.key, required this.controller});


  @override
  State<StatefulWidget> createState() => _NotifyCenterState();
}

class _NotifyCenterState extends State<NotifyCenter> {

  _NotifyCenterMessage? _message;

  @override
  void initState() {
    super.initState();
    _message = widget.controller._message;
    widget.controller.addListener(_processMessage);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_processMessage);
  }

  void _processMessage() {
    setState(() {
      _message = widget.controller._message;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_message == null) return Container();

    List<Widget> children = [];

    _NotifyCenterMessage message = _message!;
    if (message.currentMessage != null) {
      children.add(_buildBanner(message.currentMessage!));
    }

    if (message.nextMessage != null) {
      children.add(_buildBanner(message.nextMessage!));
    }

    if (message.remainCount > 0) {
      children.add(_buildFooter(message.remainCount));
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
        dynamic param = message.referenceId;
        switch (config.type) {
          case BannerType.fire:
            routeName = FireDetailPage.routeName;
            break;
          case BannerType.none:
            break;
          case BannerType.alarm:
            routeName = AlarmFaultDetailPage.routeName;
            param = AlarmDetailParam(alarmId: message.referenceId!, type: AlarmDetailType.alarm);
            break;
          case BannerType.fault:
            routeName = AlarmFaultDetailPage.routeName;
            param = AlarmDetailParam(alarmId: message.referenceId!, type: AlarmDetailType.fault);
            break;
          case BannerType.trouble:
            routeName = TroubleDetailPage.routeName;
            break;
          case BannerType.danger:
            routeName = DangerDetailPage.routeName;
            break;
        }

        if (routeName.isNotEmpty) {
          Navigator.pushNamed(context, routeName, arguments: param);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: config.bgColor,
          borderRadius: BorderRadius.circular(10)
        ),
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(config.iconData, size: 18),
                  ),
                  Expanded(child: Text(config.name)),
                  Text(message.time),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(Icons.close, size: 18,)
                    ),
                    onTap: () {
                      widget.controller._closeMessage(message);
                    },)
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: Text(
                        message.title,
                        style: const TextStyle(fontSize: 14.0)
                      )
                  ),
                  const Icon(Icons.arrow_forward, size: 15,)
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
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                color: Color(0xffeceff1)
            ),
            child: Text(
                "还剩$count条通知",
                style: const TextStyle(color: Color(0xff607d8b))
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.controller._closeNotifyCenter();
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                  color: Color(0xff455A64)
              ),
              child:  const Text(
                  "清除消息",
                  style: TextStyle(color: Color(0xffeceff1))
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotifyCenterMessage {
  // 当前播放的横幅信息
  NotifyMessage? currentMessage;

  // 即将播放的横幅信息
  NotifyMessage? nextMessage;

  // 剩余的信息数量
  int remainCount = 0;

}

class NotifyCenterController extends ChangeNotifier {

  // 待播报的信息
  final List<NotifyMessage> _remainMessages = [];

  // 正在播报的信息
  late NotifyMessage _playingMessage;

  // 通知的消息封装
  final _NotifyCenterMessage _message = _NotifyCenterMessage();

  OverlaySupportEntry? _entry;

  AudioPlayer? _player;

  static const int _retry = 2;

  String token = "";

  void processMessage(NotifyMessage message) {
    if (_message.currentMessage == null) {
      _message.currentMessage = message;
      _showNotifyCenter();
      _playAudio(message);
    } else if (_message.nextMessage == null) {
      _message.nextMessage = message;
    } else {
      _remainMessages.add(message);
      _message.remainCount = _remainMessages.length;
    }
    notifyListeners();
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
        _closeMessage(_playingMessage);
      }
    });
  }

  void _closeMessage(NotifyMessage message) {
    if (_message.currentMessage == message) {
      if (_message.nextMessage == null) {
        _closeNotifyCenter();
        //最后一条消息,直接关闭通知,不需要通知监听
        return;
      } else {
        _message.currentMessage = _message.nextMessage;
        _playAudio(_message.currentMessage);
        _setNextMessage();
      }
    } else if (_message.nextMessage == message) {
      _setNextMessage();
    }
    notifyListeners();
  }

  void _setNextMessage() {
    _message.nextMessage = _remainMessages.isNotEmpty ? _remainMessages.removeAt(0) : null;
    _message.remainCount = _remainMessages.length;
  }

  void _closeNotifyCenter() {
    _entry?.dismiss();
    _entry = null;

    _message.currentMessage = null;
    _message.nextMessage = null;
    _message.remainCount = 0;

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
