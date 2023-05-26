import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/home_api.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DangerReport extends StatefulWidget {
  const DangerReport({super.key, required this.param});
  final DangerUpdateParam param;
  @override
  State<DangerReport> createState() => _FireReportState();
}

class _FireReportState extends State<DangerReport> {
  late List<DangerType> types = [];
  late FixedExtentScrollController _controller;
  late int _selected = 0;
  late DangerType? _type = null;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    types = await HomeApi.getDangerType();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardParent(
            header: Row(children: [
              Container(width: 3, height: 14, color: FcColor.baseColor, margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
              const Expanded(
                flex: 1,
                child: Text('危险品信息'),
              ),
            ]),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      const Expanded(flex: 1, child: Text('危险品名称')),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "请填写危险品名称",
                            // border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            widget.param.name = value;
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
                      const Expanded(flex: 1, child: Text('类型')),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                            onTap: () {
                              showTypeModal();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 180),
                                  child: Text(
                                    _type != null ? _type!.name : '请填写危险品类型',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: _type != null ? const Color(0xFF030303) : const Color(0xFF999999),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Color(0xFF999999),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            )),
        CardParent(
            header: Row(children: [
              Container(width: 3, height: 14, color: FcColor.baseColor, margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
              const Expanded(
                flex: 1,
                child: Text('危险品描述'),
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

  late StateSetter _pickerSetter;
  showTypeModal() {
    MediaQueryData data = MediaQuery.of(context);
    _controller = FixedExtentScrollController(initialItem: _selected);
    // double pickerHeight = widget.search ? 420.0 : 300;
    showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
              height: 300,
              padding: const EdgeInsets.all(10),
              width: data.size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "取消",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, _controller.selectedItem);
                        },
                        child: const Text(
                          "确认",
                          style: TextStyle(color: FcColor.info),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                        _pickerSetter = stateSetter;
                        return CupertinoPicker(
                          scrollController: _controller,
                          itemExtent: 50, //行高
                          onSelectedItemChanged: (value) {},
                          children: types.map((data) {
                            return Center(
                              child: Text(
                                data.name!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(growable: false),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )).then((value) {
      if (value != null) {
        _type = types[value];
        widget.param.type = _type!.id;
        _selected = value;
      } else {
        _selected = 0;
      }
      setState(() {});
    });
  }
}
