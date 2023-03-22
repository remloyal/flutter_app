import 'package:flutter/material.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/alarm_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/analog_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/danger_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/fault_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/fire_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/remind_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/risk_list.dart';
import 'package:fire_control_app/pages/alarm/alarm_main/trouble_list.dart';


class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<StatefulWidget> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["火情", "报警", "故障", "隐患", "危险品", "风险", "提醒"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: TabBar(
                  tabs: tabs.map((e) => Tab(text: e)).toList(),
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.red,
                  // dividerColor: const Color.fromARGB(255, 245, 0, 0),
                  indicatorColor: Colors.red,
                  unselectedLabelColor: Color.fromARGB(255, 0, 0, 0),
                )),
            IconButton(onPressed: () {}, icon: Icon(Icons.warning))
          ],
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
              //构建
              controller: _tabController,
              children: [FireList(),AlarmList(),FaultList(),TroubleList(),DangerList(),RiskList(),ReminfList()]),
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
}
