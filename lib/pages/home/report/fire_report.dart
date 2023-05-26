import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/material.dart';

class FireReport extends StatefulWidget {
  const FireReport({super.key, required this.param});
  final FileUpdateParam param;
  @override
  State<FireReport> createState() => _FireReportState();
}

class _FireReportState extends State<FireReport> {
  @override
  Widget build(BuildContext context) {
    return CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 14,
              color: FcColor.baseColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('事件描述'),
          ),
        ]),
        body: Column(
          children: [
            TextField(
              maxLines: 10,
              minLines: 1,
              maxLength: 140,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontSize: 14, height: 1.5),
              onChanged: (value) {
                widget.param.remark = value;
              },
              decoration: const InputDecoration(
                hintText: "请输入描述内容，可使用输入法自带的语音转文字功能实现快速录入",
                border: InputBorder.none,
              ),
            ),
          ],
        ));
  }
}
