import 'package:flutter/material.dart';

class Popup extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  Widget child;
  final Color? bgColor;

  Popup({
    required this.child,
    this.bgColor,
  });

  @override
  Color get barrierColor =>
      bgColor != null ? bgColor! : Colors.black.withAlpha(127);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
