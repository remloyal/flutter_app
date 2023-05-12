import 'package:fire_control_app/common/fc_color.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/pages/mine/mine_external/mine_external_list.dart';

class MineHelp extends StatefulWidget {
  const MineHelp({super.key});

  @override
  State<MineHelp> createState() => _MineHelpState();
}

class _MineHelpState extends State<MineHelp>
    with SingleTickerProviderStateMixin {
  late bool loadingState = false;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadingState = true;
    // _mineWorkCommon.init();
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '帮助中心',
      roll: false,
      body: [_tabar(), _tabBarView()],
    );
  }

  Widget _tabar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: FcColor.cardColor,
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFDFDFDF)),
          )),
      child: SizedBox(
        // width: 280,
        height: 46,
        child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.red,
            dividerColor: const Color.fromARGB(255, 245, 0, 0),
            indicatorColor: Colors.red,
            unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
            indicatorWeight: 3,
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
            ),
            labelStyle: const TextStyle(fontSize: 14, height: 2),
            tabs: [
              ...[
                '常见问题',
                '消防平台',
                '巡检移动端',
              ].map((item) {
                return Tab(
                  text: item,
                );
              }).toList(),
            ]),
      ),
    );
  }

  Widget _tabBarView() {
    return Expanded(
        child: TabBarView(controller: _tabController, children: const [
      MineLoadList(
        url: 'http://m1.jsca119.cn/help/302/',
        type: 'help',
      ),
      MineLoadList(
        url: 'http://m1.jsca119.cn/help/303/',
        type: 'help',
      ),
      MineLoadList(
        url: 'http://m1.jsca119.cn/help/305/',
        type: 'help',
      ),
    ]));
  }
}
