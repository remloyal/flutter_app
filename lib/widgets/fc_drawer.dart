import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/fc_icon.dart';
import 'package:flutter/material.dart';

class RightDrawer extends StatefulWidget {
  // 占屏幕宽度得百分比，默认0.6
  final double ratio;

  final Widget? body;

  const RightDrawer({super.key, this.body, this.ratio = 0.7});

  @override
  State<StatefulWidget> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _controller.forward();
  }

  ///关闭页面动画
  void _close() {
    _controller.reverse().then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    //获取屏幕尺寸
    MediaQueryData data = MediaQuery.of(context);
    double width = data.size.width;
    double height = data.size.height;

    double finalWidth = width * widget.ratio;

    //设置动画
    final CurvedAnimation curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Animation<RelativeRect> animation = RelativeRectTween(
        begin: RelativeRect.fromLTRB(finalWidth, 0, -finalWidth, 0),
        end: const RelativeRect.fromLTRB(0, 0, 0, 0)
    ).animate(curve);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _close,
            child: Container(
              color: Colors.transparent,
              width: width,
              height: height,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: finalWidth,
              height: height,
              child: Stack(
                children: [
                  PositionedTransition(
                    rect: animation,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
                          color: Colors.white
                      ),
                      width: finalWidth,
                      height: height,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: data.padding.top + 20,
                            bottom: data.padding.bottom + 10
                        ),
                        child: widget.body,
                      ),
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

showRightDrawer({required BuildContext context, required WidgetBuilder builder}) {
  showDialog(
      context: context,
      useSafeArea: false,
      builder: (ctx) => RightDrawer(
        body: builder(ctx),
      )
  );
}

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
        showRightDrawer(
            context: context,
            builder: (ctx) => _FilterContainer(
                body: filterBodyBuilder(ctx),
                controller: controller
            )
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Row(
          children: [
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
    return Column(
      children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: body
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: FcColor.err)
          ),
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
                    state?._close();
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
