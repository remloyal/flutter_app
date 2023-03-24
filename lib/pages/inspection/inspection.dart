import 'package:fire_control_app/common/colors.dart';
import 'package:fire_control_app/pages/inspection/route_list.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/pages/inspection/plan_list.dart';

class Inspection extends StatefulWidget {
  const Inspection({super.key});

  @override
  State<StatefulWidget> createState() => _InspectionState();
}

class _InspectionState extends State<Inspection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["任务列表", "路线列表"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          color: FireControlColor.cardColor,
          child: TabBar(
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            controller: _tabController,
            labelColor: Colors.red,
            indicatorColor: Colors.red,
            unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
              //构建
              controller: _tabController,
              children: const [
                PlanList(),
                RouteList(),
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
}
