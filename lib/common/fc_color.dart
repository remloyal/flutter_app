import 'package:flutter/material.dart';

class FcColor {
  // 基础颜色
  static const Color baseColor = Color(0xffe53935);
  static const Color barColor = Color(0xffe53935);
  static const Color fixedColor = Color(0xffe53935);
  static const Color barMineColor = Color(0xffffebee);
  static const Color bgColor = Color.fromARGB(255, 236, 236, 236);
  static const Color cardColor = Color(0xffFFFFFF);
  static const Color textColor = Color.fromARGB(255, 255, 255, 255);

  // 背景色
  static const Color bodyColor = Color(0xfff5f5f5);
  static const Color bodyTitleColor = Color(0xffFFFFFF);

  // 基础字体颜色
  static const Color base3 = Color(0xff333333);
  static const Color base6 = Color(0xff666666);
  static const Color base9 = Color(0xff999999);
  static const Color baseE = Color(0xffEEEEEE);
  static const Color baseF5 = Color(0xffF5F5F5);

  // 报警横幅的颜色
  static const Color bannerLevel1 = Color(0xffE53935);
  static const Color bannerLevel2 = Color(0xffFF5722);
  static const Color bannerLevel3 = Color(0xffFF9800);
  static const Color bannerLevel4 = Color(0xffFFB300);
  static const Color bannerLevel5 = Color(0xff00c2c2);
  static const Color bannerLevel6 = Color(0xff607D8B);
  static const Color bannerLevel7 = Color(0xff4CAF50);

  // 状态颜色
  static const Color err = Color(0xffE53935);
  static const Color ok = Color(0xff4CAF50);
  static const Color info = Color(0xff1976D2);
  static const Color warn = Color(0xffFF9800);

  // 筛选
  static const Color filterSelected = Color(0xff323233);
  static const Color filterHint = Color(0xffcccccc);

  // 巡检打卡
  static const Color punch = Color(0xff4acf50);
}

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = [.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
