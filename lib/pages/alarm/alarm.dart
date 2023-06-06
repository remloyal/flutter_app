import 'package:fire_control_app/models/home.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/alarm_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/danger_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/fault_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/fire_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/remind_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/risk_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/trouble_list.dart';
import 'package:fire_control_app/common/fc_color.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key, required this.alarmType});
  final AlarmType alarmType;
  @override
  State<StatefulWidget> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List tabs = ["火情", "报警", "故障", "隐患", "危险品", "风险", "提醒"];
  Map types = {
    'fire': 0,
    'alarm': 1,
    'fault': 2,
    'trouble': 3,
    'danger': 4,
    'risk': 5,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    if (widget.alarmType.type != null) {
      _tabController.index = types[widget.alarmType.type];
    }

    widget.alarmType.addListener(() {
      _tabController.index = types[widget.alarmType.type];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  color: FcColor.cardColor,
                  child: TabBar(
                    tabs: tabs.map((e) => Tab(text: e)).toList(),
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.red,
                    // dividerColor: const Color.fromARGB(255, 245, 0, 0),
                    indicatorColor: Colors.red,
                    unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                )),
            Container(
                color: FcColor.cardColor,
                height: 48,
                padding: const EdgeInsets.only(right: 6),
                child: InkWell(
                  onTap: () {
                    showDialogFunction();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Color(0xffFF9800),
                      ),
                      Text(
                        '说明',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffFF9800),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
              //构建
              controller: _tabController,
              children: [
                FireList(),
                AlarmList(),
                FaultList(),
                TroubleList(),
                DangerList(),
                RiskList(),
                RemindList()
              ]),
        )
      ],
    );
  }

  @override
  void dispose() {
    // 释放资源
    _tabController.dispose();
    super.dispose();
  }

  final List illustrate = [
    {"text": '发生/开始时间', 'icon': const IconData(0xe897, fontFamily: 'fcm')},
    {"text": '持续时间', 'icon': const IconData(0xe806, fontFamily: 'fcm')},
    {"text": '关闭/结束时间', 'icon': const IconData(0xe6ca, fontFamily: 'fcm')},
    {"text": '操作/处理时间', 'icon': const IconData(0xe6c5, fontFamily: 'fcm')},
    {"text": '复位时间', 'icon': const IconData(0xe66a, fontFamily: 'fcm')},
  ];

  showDialogFunction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    IconData(0xe617, fontFamily: 'fcm'),
                    size: 16,
                  ),
                ),
                Text(
                  '时间图标说明',
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            titlePadding: const EdgeInsets.all(8),
            contentPadding: const EdgeInsets.all(10),
            content: SingleChildScrollView(
                child: Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 8.0,
              children: [
                ...illustrate.map((data) {
                  return setWarpItem(data['icon'], data['text']);
                }).toList()
              ],
            )));
      },
    );
  }

  Widget setWarpItem(icon, text) {
    return Container(
      width: 124,
      padding: const EdgeInsets.all(6),
      decoration:
          BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              icon,
              size: 18,
            ),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
