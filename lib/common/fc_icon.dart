import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// 自定义的字体图标
class FcmIcon {
  // 综合
  static const home = IconData(0xe613, fontFamily: 'fcm');

  // 巡检
  static const inspection = IconData(0xe656, fontFamily: 'fcm');

  // 告警
  static const alarm = IconData(0xe638, fontFamily: 'fcm');

  // 设备
  static const device = IconData(0xe603, fontFamily: 'fcm');

  // 我的
  static const mine = IconData(0xe6df, fontFamily: 'fcm');

  // 消息
  static const message = IconData(0xe8be, fontFamily: 'fcm');

  // 扫一扫
  static const scan = IconData(0xe62f, fontFamily: 'fcm');

  // 单位
  static const unit = IconData(0xe626, fontFamily: 'fcm');

  // 双向箭头
  static const exchangeArrow = IconData(0xe62d, fontFamily: 'fcm');

  // 关闭
  static const close = IconData(0xe690, fontFamily: 'fcm');

  // 筛选
  static const filter = IconData(0xe628, fontFamily: 'fcm');

  // 闪光灯
  static const light = IconData(0xe609, fontFamily: 'fcm');

  // 标记已读
  static const read = IconData(0xe80b, fontFamily: 'fcm');
}

/// 报警相关的图标
class MsgIcon {
  // 告警
  static const alarm = IconData(0xe6d3, fontFamily: 'fcm');

  // 火情
  static const fire = IconData(0xe66c, fontFamily: 'fcm');

  // 故障
  static const fault = IconData(0xe612, fontFamily: 'fcm');

  // 隐患
  static const trouble = IconData(0xe637, fontFamily: 'fcm');

  // 危险品
  static const danger = IconData(0xe69d, fontFamily: 'fcm');

  // 提醒
  static const remind = IconData(0xe6d1, fontFamily: 'fcm');

  // 风险
  static const risk = IconData(0xe627, fontFamily: 'fcm');

  // 巡检
  static const inspection = IconData(0xe656, fontFamily: 'fcm');
}

// 设备类型图标
class DeviceFont {
  DeviceFont._();
  static Map<String, IconData> iconMap = {};

  static Future<void> loadRemoteFont(fontfamily) async {
    var url = Uri.parse('https://stdos.zhxf.ltd/fcstd/css/devices_move/iconfont.ttf');
    var fontData = await http.readBytes(url);
    var fontLoader = FontLoader(fontfamily);
    fontLoader.addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
    // print('加载字体成功 =====>');
  }

  static getDeviceJson() async {
    // String jsonData = await rootBundle.loadString("assets/fonts/device.json");
    var url = Uri.parse('https://stdos.zhxf.ltd/fcstd/css/devices_move/iconfont.json');
    String jsonData = await http.read(url);
    final jsonresult = json.decode(jsonData);
    final fontfamily = jsonresult['font_family'];
    // final css_prefix_text = jsonresult['css_prefix_text'];
    final List icons = jsonresult['glyphs'];
    loadRemoteFont(fontfamily);
    for (var element in icons) {
      int redColor = int.parse("0x${element['unicode']}");
      iconMap[element['font_class']] = IconData(redColor, fontFamily: fontfamily);
    }
  }
}
