import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/material.dart';

class TroubleReport extends StatefulWidget {
  const TroubleReport({super.key, required this.param});
  final TroubleUpdateParam param;
  @override
  State<TroubleReport> createState() => _FireReportState();
}

class _FireReportState extends State<TroubleReport> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardParent(
            header: Row(children: [
              Container(
                  width: 3,
                  height: 14,
                  color: FcColor.baseColor,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
              const Expanded(
                flex: 1,
                child: Text('隐患信息'),
              ),
            ]),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      const Expanded(flex: 1, child: Text('隐患类型')),
                      Expanded(
                        flex: 3,
                        child: ButtonBarState(
                          index: widget.param.type,
                          names: const [
                            {'text': '损坏', 'value': 1},
                            {'text': '人为风险', 'value': 2},
                            {'text': '非人为风险', 'value': 3},
                            {'text': '缺失', 'value': 4}
                          ],
                          onTap: (index) {
                            // _deviceParam.alarm = index;
                            widget.param.type = index;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      const Expanded(flex: 1, child: Text('紧急程度')),
                      Expanded(
                        flex: 3,
                        child: ButtonBarState(
                          index: widget.param.levels,
                          names: const [
                            {'text': '高', 'value': 3},
                            {'text': '中', 'value': 2},
                            {'text': '低', 'value': 1},
                          ],
                          onTap: (index) {
                            widget.param.levels = index;
                            // _deviceParam.alarm = index;
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
        CardParent(
            header: Row(children: [
              Container(
                  width: 3,
                  height: 14,
                  color: FcColor.baseColor,
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
              const Expanded(
                flex: 1,
                child: Text('隐患描述'),
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
                    widget.param.cont = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "请输入描述内容，可使用输入法自带的语音转文字功能实现快速录入",
                    border: InputBorder.none,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
