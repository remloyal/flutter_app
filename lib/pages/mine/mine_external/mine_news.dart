import 'package:fire_control_app/common/fc_color.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/pages/mine/mine_external/mine_external_list.dart';

class MineNews extends StatefulWidget {
  const MineNews({super.key});

  @override
  State<MineNews> createState() => _MineNewsState();
}

class _MineNewsState extends State<MineNews>
    with SingleTickerProviderStateMixin {
  late bool loadingState = false;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadingState = true;
    // _mineWorkCommon.init();
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '新闻资讯',
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
                '公司动态',
                '行业新闻',
                '政策法规',
                '安全事故',
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
        url: 'http://m1.jsca119.cn/news/corporation/',
        type: 'news',
      ),
      MineLoadList(
        url: 'http://m1.jsca119.cn/news/industry/',
        type: 'news',
      ),
      MineLoadList(
        url: 'http://m1.jsca119.cn/news/policy/',
        type: 'news',
      ),
      MineLoadList(
        url: 'http://m1.jsca119.cn/news/safety/',
        type: 'news',
      ),
    ]));
  }
}
