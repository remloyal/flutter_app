import 'package:fire_control_app/common/fc_color.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/pages/inspection/inspection_list.dart';

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
          color: FcColor.cardColor,
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
              children: [
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
