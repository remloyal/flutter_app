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
                  SelectableText.rich(TextSpan(
                    text: content ?? '-',
                    style: const TextStyle(fontSize: 12),
                  ))
              // Text(
              //   content ?? '',
              //   softWrap: true,
              //   textAlign: TextAlign.left,
              //   overflow: TextOverflow.ellipsis,
              //   maxLines: 3,
              //   style: const TextStyle(fontSize: 12),
              // ),
              )
        ],
      ),
    );
  }
}
