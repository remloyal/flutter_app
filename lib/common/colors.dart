import 'package:flutter/material.dart';

class FireControlColor {
  // 基础颜色
  static const Color baseColor = Color(0xffe53935);
  static const Color barColor = Color(0xffe53935);
  static const Color fixedColor = Color(0xffe53935);
  static const Color barMineColor = Color(0xffffebee);
  static const Color bgColor = Color(0xffF5F5F5);
  static const Color textColor = Color.fromARGB(255, 255, 255, 255);

  // 基础字体颜色
  static const Color base3 = Color(0xff030303);

  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };
    return MaterialColor(color.value, shades);
  }
}
