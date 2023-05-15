import 'dart:ui';

import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/fc_icon.dart';
import 'package:flutter/material.dart';

double getScreenWidth() {
  return window.physicalSize.width / window.devicePixelRatio;
}

double getScreenHeight() {
  return window.physicalSize.height / window.devicePixelRatio;
}

class RightDrawer extends StatefulWidget {
  // 占屏幕宽度得百分比，默认0.6
  final double ratio;

  final Widget? body;

  const RightDrawer({super.key, this.body, this.ratio = 0.7});

  @override
  State<StatefulWidget> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer>
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

  ///关闭页面动画
  void close() {
    _controller.reverse().then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double width = data.size.width;
    double height = data.size.height -
        data.systemGestureInsets.top -
        data.systemGestureInsets.bottom;
    double left = width - _width;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              width: width,
              height: height,
            ),
            onTap: () => close(),
          ),
          Positioned(
            left: left,
            top: 0,
            child: SizedBox(
              width: _width,
              height: height,
              child: Stack(
                children: [
                  PositionedTransition(
                    rect: _animation,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(15)),
                          color: Colors.white),
                      width: _width,
                      height: height,
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

typedef WidgetsBuilder = List<Widget> Function(BuildContext context);

class FilterButton extends StatelessWidget {
  final WidgetsBuilder filterBodyBuilder;

  final FilterController controller;

  const FilterButton(
      {super.key,
      required this.filterBodyBuilder,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => RightDrawer(
                  body: _FilterContainer(
                    controller: controller,
                    body: filterBodyBuilder(ctx),
                  ),
                ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          children: const [
            Icon(
              FcmIcon.filter,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('筛选'),
            )
          ],
        ),
      ),
    );
  }
}

class _FilterContainer extends StatelessWidget {
  final List<Widget> body;

  final FilterController controller;

  const _FilterContainer({
    required this.body,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      child: Column(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: body),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: FcColor.err)),
            margin: const EdgeInsets.only(top: 10),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      controller._reset();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                      child: const Text(
                        '重置条件',
                        style: TextStyle(color: FcColor.baseColor),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      _RightDrawerState? state =
                          context.findAncestorStateOfType<_RightDrawerState>();
                      state?.close();
                      if (controller.confirm != null) {
                        controller.confirm!();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: FcColor.err,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        '确定',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FilterController extends ChangeNotifier {

  VoidCallback? reset;
  VoidCallback? confirm;

  FilterController({this.reset, this.confirm});


  void _reset() {
    if (reset != null) reset!();
    notifyListeners();
  }
}
