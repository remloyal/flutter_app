import 'package:flutter/material.dart';
import 'package:fire_control_app/common/colors.dart';

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
        color: FireControlColor.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(children: [
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
            '$label：',
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

class CardTitle extends StatelessWidget {
  const CardTitle({super.key, required this.text, this.right});
  final String text;
  final Widget? right;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Container(
          width: 4,
          height: 13,
          // color: FireControlColor.baseColor,
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          decoration: BoxDecoration(
            color: FireControlColor.baseColor,
            border: Border.all(width: 1, color: Colors.red),
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        right ??
            Container(
              height: 0,
            )
      ]),
      const Divider(
        indent: 0.0,
        color: Color.fromARGB(255, 190, 190, 190),
      ),
    ]);
  }
}
