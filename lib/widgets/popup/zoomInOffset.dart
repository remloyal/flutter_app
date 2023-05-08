import 'package:flutter/material.dart';

class ZoomInOffset extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  final CartoonConfig cartoonConfig;

  ///把控制器通过函数传递出去，可以在父组件进行控制
  final Function(AnimationController) controller;
  final bool manualTrigger;
  final bool animate;

  ZoomInOffset(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 500),
      this.delay = const Duration(milliseconds: 0),
      required this.controller,
      this.manualTrigger = false,
      this.animate = true,
      required this.cartoonConfig}) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  State<ZoomInOffset> createState() => _ZoomInState();
}

class _ZoomInState extends State<ZoomInOffset>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool disposed = false;
  late Animation<double> fade;
  late Animation<double> opacity;

  @override
  void dispose() async {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: widget.cartoonConfig.duration, vsync: this);
    fade = Tween(
            begin: widget.cartoonConfig.begin, end: widget.cartoonConfig.end)
        .animate(CurvedAnimation(curve: Curves.easeOut, parent: controller));

    opacity = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: const Interval(0, 0.65)));

    if (!widget.manualTrigger && widget.animate) {
      Future.delayed(widget.delay, () {
        if (!disposed) {
          controller.forward();
        }
      });
    }
    widget.controller(controller);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate && widget.delay.inMilliseconds == 0) {
      controller.forward();
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          origin: widget.cartoonConfig.offset,
          scale: fade.value,
          alignment: widget.cartoonConfig.alignment,
          child: Opacity(
            opacity: opacity.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class CartoonConfig {
  final double? begin;
  final double? end;
  final AlignmentGeometry? alignment;
  final Offset? offset;
  final Duration? duration;
  const CartoonConfig({
    this.begin = 0.0,
    this.end = 1.0,
    this.alignment = Alignment.center,
    this.offset,
    this.duration = const Duration(milliseconds: 250),
  });
}
