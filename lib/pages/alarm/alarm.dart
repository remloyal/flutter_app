import 'package:flutter/material.dart';

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
              children: tabs.map((e) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(e, textScaleFactor: 5),
                );
              }).toList()),
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
