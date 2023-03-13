import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message {
  static show(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static error(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color(0xffFEF0F0),
        textColor: const Color.fromARGB(255, 255, 0, 0),
        fontSize: 16.0);
  }
}
