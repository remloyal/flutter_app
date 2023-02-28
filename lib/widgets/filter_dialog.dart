import 'dart:ui';

import 'package:flutter/material.dart';

double getScreenWidth() {
  return window.physicalSize.width / window.devicePixelRatio;
}

double getScreenHeight() {
  return window.physicalSize.height / window.devicePixelRatio;
}

class FilterDialog extends StatefulWidget {
  // 占屏幕宽度得百分比，默认0.6
  final double ratio;

  final Widget? body;

  const FilterDialog({super.key, this.body, this.ratio = 0.7});

  @override
  State<StatefulWidget> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog>
    with SingleTickerProviderStateMixin {
  late double _width;
  late AnimationController _controller;
  late Animation<RelativeRect> _animation;

  @override
  void initState() {
    super.initState();
    _width = getScreenWidth() * widget.ratio;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    final CurvedAnimation curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _animation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(_width, 0, -_width, 0),
            end: const RelativeRect.fromLTRB(0, 0, 0, 0))
        .animate(curve);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("build filter");
    double left = getScreenWidth() - _width;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              width: getScreenWidth(),
              height: getScreenHeight(),
            ),
            onTap: () => Navigator.pop(context),
          ),
          Positioned(
            left: left,
            top: 0,
            child: SizedBox(
              width: _width,
              height: getScreenHeight(),
              child: Stack(
                children: [
                  PositionedTransition(
                    rect: _animation,
                    child: Container(
                      color: Colors.white,
                      width: _width,
                      height: getScreenHeight(),
                      child: widget.body,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
