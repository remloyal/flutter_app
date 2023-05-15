import 'package:flutter/material.dart';
import 'package:fire_control_app/common/fc_color.dart';

class CardParent extends StatefulWidget {
  const CardParent(
      {super.key, required this.header, required this.body, this.fotter});

  final Widget header;
  final Widget body;
  final Widget? fotter;

  @override
  State<CardParent> createState() => _CardParentState();
}

class _CardParentState extends State<CardParent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: FcColor.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        widget.header,
        const Divider(
          indent: 0.0,
          color: Color.fromARGB(255, 190, 190, 190),
        ),
        widget.body,
        widget.fotter == null
            ? Container(
                height: 0,
              )
            : const Divider(
                indent: 0.0,
                color: Color.fromARGB(255, 190, 190, 190),
              ),
        Opacity(
          opacity: widget.fotter == null ? 0 : 1,
          child: widget.fotter,
        ),
        // widget.fotter,
      ]),
    );
  }
}

class CardContainer extends StatelessWidget {
  // 背景色
  final Color? backgroundColor;

  // 底部是否设置margin，默认设置
  final bool bottomMargin;

  // 内容
  final List<Widget> children;

  final CrossAxisAlignment crossAxisAlignment;

  const CardContainer(
      {super.key,
      this.bottomMargin = true,
      this.backgroundColor,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      required this.children});

  @override
  Widget build(BuildContext context) {
    double space = 10.0;
    EdgeInsets margin = EdgeInsets.only(left: space, top: space, right: space);
    if (bottomMargin) {
      margin = EdgeInsets.all(space);
    }
    return Container(
        margin: margin,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor ?? FcColor.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ));
  }
}

class CardDivider extends StatelessWidget {
  const CardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 0.0,
      color: Color.fromARGB(255, 190, 190, 190),
    );
  }
}

class CardHeader extends StatelessWidget {
  final Color leadingColor;
  final String title;
  final Widget? tail;
  final bool divider;
  final bool standStart;

  const CardHeader(
      {super.key,
      required this.title,
      this.leadingColor = FcColor.baseColor,
      this.tail,
      this.divider = true,
      this.standStart = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          if (standStart)
            Container(
                width: 4,
                height: 13,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                decoration: BoxDecoration(
                  color: leadingColor,
                  border: Border.all(width: 1, color: leadingColor),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                )),
          Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(fontSize: 12),
              )),
          tail ?? Container()
        ]),
        if (divider) const CardDivider(),
      ],
    );
  }
}

class CardFooter extends StatelessWidget {
  final Widget? left;
  final Widget? right;

  const CardFooter({super.key, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CardDivider(),
        Row(
          children: [
            if (left != null) Expanded(child: left!),
            if (right != null) Expanded(child: right!),
          ],
        )
      ],
    );
  }
}

class XfItem extends StatelessWidget {
  final String label;
  final String? content;
  final double? rowHeight;
  final Widget? contentWidget;

  const XfItem(
      {super.key,
      required this.label,
      this.content,
      this.rowHeight,
      this.contentWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: rowHeight ?? 2, bottom: rowHeight ?? 2),
      child: Row(
        children: [
          Text(
            '$label\u3000',
            style: const TextStyle(fontSize: 12, color: Color(0xff999999)),
          ),
          Expanded(
            child: contentWidget ??
                // SelectableText.rich(TextSpan(
                //   text: content ?? '-',
                //   style: const TextStyle(fontSize: 12),
                // ))
                // SelectableText(
                //   content ?? '-',
                //   style: const TextStyle(fontSize: 12),
                //   // ignore: deprecated_member_use
                //   toolbarOptions: ToolbarOptions(
                //       copy: true, selectAll: true, paste: true, cut: true),
                // )
                Text(
                  content ?? '',
                  softWrap: true,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12),
                ),
          )
        ],
      ),
    );
  }
}

class UserContent extends StatelessWidget {
  final String? name;
  final String? phone;

  const UserContent({super.key, this.name, this.phone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(name ?? '-'),
        const SizedBox(
          width: 10,
        ),
        if (phone != null)
          Container(
            padding:
                const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: const Color(0xffE3F2FD),
                border: Border.all(color: const Color(0xff1976D2), width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                const Icon(
                  Icons.local_phone,
                  color: Color(0xff1976D2),
                  size: 10,
                ),
                Text(
                  phone!,
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xff1976D2)),
                ),
              ],
            ),
          )
      ],
    );
  }
}

class ErrorContent extends StatelessWidget {
  final String? message;

  const ErrorContent({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message ?? '-',
      style: const TextStyle(fontSize: 12, color: Colors.red),
    );
  }
}

class TaskCodeContent extends StatelessWidget {
  final String? taskCode;

  const TaskCodeContent({super.key, this.taskCode});

  @override
  Widget build(BuildContext context) {
    return Text(taskCode ?? '-',
        style: const TextStyle(color: FcColor.info, fontSize: 12));
  }
}

class TroubleLevelContent extends OutlinedContent {
  final bool handled;
  final int level;

  const TroubleLevelContent(
      {super.key, required this.level, this.handled = false});

  @override
  Color getBackgroundColor() {
    if (handled) return const Color(0xffF5F5F5);
    if (level == 1) return const Color(0xffFFF8E1);
    if (level == 2) return const Color(0xffFFF3E0);
    return const Color(0xffffebee);
  }

  @override
  String getText() {
    return level == 1
        ? '低'
        : level == 2
            ? '中'
            : '高abd';
  }

  @override
  Color getTextColor() {
    if (handled) return const Color(0xffAAAAAA);
    if (level == 1) return const Color(0xffFFB300);
    if (level == 2) return const Color(0xffFF9800);
    return const Color(0xffE53935);
  }
}

abstract class OutlinedContent extends StatelessWidget {
  const OutlinedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: getTextColor())),
      child: Text(
        getText(),
        style: TextStyle(fontSize: 13, color: getTextColor()),
      ),
    );
  }

  Color getBackgroundColor();

  Color getTextColor();

  String getText();
}

class TaskStatusContent extends OutlinedContent {
  final int status;

  const TaskStatusContent({super.key, required this.status});

  @override
  Color getBackgroundColor() {
    if (status == 1) return const Color(0xffE3F2FD);
    if (status == 2) return const Color(0xffE8F5E9);
    return const Color(0xffFFEBEE);
  }

  @override
  String getText() {
    return status == 1
        ? "执行中"
        : status == 2
            ? '已完成'
            : '未完成';
  }

  @override
  Color getTextColor() {
    if (status == 1) return const Color(0xff1976D2);
    if (status == 2) return const Color(0xff4CAF50);
    return const Color(0xffE53935);
  }
}

class RouteStatusContent extends OutlinedContent {
  final int status;

  const RouteStatusContent({super.key, required this.status});

  @override
  Color getBackgroundColor() {
    if (status == 1) return const Color(0xffFFF3E0);
    return const Color(0xffF5F5F5);
  }

  @override
  String getText() {
    return status == 1 ? "可领取" : '已领取';
  }

  @override
  Color getTextColor() {
    if (status == 1) return const Color(0xffFF9800);
    return const Color(0xffAAAAAA);
  }
}

class ButtonTotal extends StatefulWidget {
  const ButtonTotal(
      {super.key,
      required this.index,
      required this.list,
      required this.onChang,
      required this.total});

  final int total;
  final int index;
  final List<Map> list;
  final Function(dynamic) onChang;

  @override
  State<ButtonTotal> createState() => _ButtonTotalState();
}

class _ButtonTotalState extends State<ButtonTotal> {
  late int extent = 3;
  late int repertory = 1;

  @override
  void initState() {
    super.initState();
    extent = widget.list.length + 1;
    repertory = widget.list[0]['index'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FcColor.cardColor,
      child: Row(children: [
        Container(
          width: MediaQuery.of(context).size.width / extent,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          decoration: const BoxDecoration(
              color: FcColor.cardColor,
              border: Border(
                  right: BorderSide(width: 1, color: Color(0xFFDFDFDF)))),
          child: Column(
            children: [
              Text(widget.total.toString(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0), fontSize: 18)),
              const Text(
                '总数',
                style: TextStyle(color: Color(0xff999999), fontSize: 12),
              )
            ],
          ),
        ),
        ...widget.list.map(
          (item) {
            return InkWell(
              onTap: () {
                repertory = item['index'];
                widget.onChang(item);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / extent,
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: item['index'] == repertory
                      ? const Color(0xffFFEBEE)
                      : FcColor.cardColor,
                ),
                child: Column(
                  children: [
                    Text(item['value'] ?? '0',
                        style: TextStyle(
                            color: item['color'] ??
                                const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18)),
                    Text(
                      item['name'] ?? '未知',
                      style: const TextStyle(
                          color: Color(0xff999999), fontSize: 12),
                    )
                  ],
                ),
              ),
            );
          },
        ).toList()
      ]),
    );
  }
}
