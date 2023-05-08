import 'package:flutter/material.dart';
import './zoomInOffset.dart';
import 'dart:ui';

double getScreenWidth() {
  return window.physicalSize.width / window.devicePixelRatio;
}

double getScreenHeight() {
  return window.physicalSize.height / window.devicePixelRatio;
}

class Model extends StatefulWidget {
  final double? left; //距离左边位置 弹窗的x轴定位
  final double? top; //距离上面位置 弹窗的y轴定位
  final double? right; //距离右边位置 弹窗的x轴定位
  final double? bottom; //距离下面位置 弹窗的y轴定位
  final bool otherClose; //点击背景关闭页面
  final Widget child; //传入弹窗的样式
  final Offset? offset; // 弹窗动画的起点

  final CartoonConfig cartoonConfig;

  const Model(
      {super.key,
      required this.child,
      this.left,
      this.top,
      this.otherClose = false,
      this.offset,
      this.right,
      this.bottom,
      this.cartoonConfig = const CartoonConfig()});

  @override
  State<Model> createState() => ModelState();
}

class ModelState extends State<Model> {
  late AnimationController animateController;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
              onTap: () async {
                if (widget.otherClose) {
                } else {
                  closeModel();
                }
              },
            ),
          ),
          Positioned(
            left: widget.left,
            top: widget.top,
            right: widget.right,
            bottom: widget.bottom,
            child: ZoomInOffset(
              cartoonConfig: widget.cartoonConfig,
              controller: (AnimationController controller) {
                animateController = controller;
              },
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }

  ///关闭页面动画
  closeModel() async {
    await animateController.reverse();
    Navigator.pop(context);
  }
}
