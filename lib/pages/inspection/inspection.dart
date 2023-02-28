import 'package:fire_control_app/pages/inspection/route_list.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        TabBar(
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            controller: _tabController,
        ),
        Expanded(
          flex: 1,
          child: TabBarView( //构建
              controller: _tabController,
              children:
              [
                Container(),
                const KeepAliveWrapper(child: RouteList()),
              ]
          ),
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