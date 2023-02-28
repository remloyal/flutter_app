import 'package:fire_control_app/pages/home/unit_select.dart';
import 'package:flutter/material.dart';

/// 路由配置类
class FireControlRouter {

  // 单位选择
  static const String unitSelect = "unitSelect";
  // 消息列表
  static const String messageList = "messageList";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      unitSelect: (context) => UnitSelect()
    };
  }
}