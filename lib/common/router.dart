import 'package:fire_control_app/pages/home/unit_select.dart';
import 'package:fire_control_app/pages/index.dart';
import 'package:fire_control_app/pages/login/login.dart';
import 'package:flutter/material.dart';

/// 路由配置类
class RouterUtil {

  // 登录页面
  static const String login = "login";
  // 主页
  static const String index = "index";
  // 单位选择
  static const String unitSelect = "unitSelect";
  // 消息列表
  static const String messageList = "messageList";

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const Login(),
    index: (context) => const IndexPage(),
    unitSelect: (context) => UnitSelect(),
  };
}