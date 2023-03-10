// websockt及友盟推送
import 'dart:convert';

import 'package:fire_control_app/common/constants.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/common/log.dart';
import 'package:fire_control_app/models/notification.dart';
import 'package:fire_control_app/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:umeng_push_sdk/umeng_push_sdk.dart';

class Push {
  static void initPush() async {
    if (!Global.isRelease) {
      UmengPushSdk.setLogEnable(true);
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

  static void removePush() async {
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
      webSocketConnectHeaders: {
        'user-agent': Constants.userAgent
      },
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

          }
        });
  }
}

class Banner {

  static late FToast _toast;
  static late bool _isShow;
  static late List<NotifyMessage> _messages;

  static initWithToast(FToast toast) {
    _toast = toast;
    _isShow = false;
    _messages = [];
  }

  // static void showBanner(NotifyMessage message) {
  //   if (!_isShow) {
  //     _toast.showToast(child: child)
  //   }
  // }
  //
  // static Widget _buildBanner
}

class NotifyCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotifyCenterState();

}

class _NotifyCenterState extends State<NotifyCenter> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
