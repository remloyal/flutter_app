import 'package:flutter/material.dart';
import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/pages/mine/mine_work/mine_fire_list.dart';
import 'package:fire_control_app/pages/mine/mine_work/mine_alarm_list.dart';
import 'package:fire_control_app/pages/mine/mine_work/mine_inspection_list.dart';
import 'package:fire_control_app/pages/mine/mine_work/mine_danger_list.dart';
import 'package:fire_control_app/pages/mine/mine_work/mine_trouble_list.dart';
import 'package:fire_control_app/widgets/picker/picker_route.dart';
import 'package:fire_control_app/utils/fire_date.dart';

class MainWorkMain extends StatefulWidget {
  const MainWorkMain({super.key, this.name, this.id});
  final String? name;

  final int? id;
  @override
  State<MainWorkMain> createState() => _MainWorkMainState();
}

class _MainWorkMainState extends State<MainWorkMain>
    with SingleTickerProviderStateMixin {
  late bool loadingState = false;
  TabController? _tabController;
  // late GlobalKey _tabBarViewKey = GlobalKey();
  final MineWorkCommon _mineWorkCommon = MineWorkCommon();

  late String present = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    loadingState = true;
    _mineWorkCommon.init();
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.name} --------- ${widget.id}');
    return FcDetailPage(
      roll: false,
      loadingState: loadingState,
      title: '${widget.name ?? "我的"}工作日志',
      body: loadingState == false ? [] : [_tabar(), _tabBarView()],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 280,
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
                  ...['火情', '报警', '巡检', '隐患', '危险品'].map((item) {
                    return Tab(
                      text: item,
                    );
                  }).toList(),
                ]),
          ),
          InkWell(
            onTap: () async {
              final List<List> timeData = getPickerConfig();
              onchange(res, position) {
                _mineWorkCommon.setTime('${res[0]}-${res[1]}');
                setState(() {});
                _mineWorkCommon.change();
              }

              late List timeData2Select = [];
              showMultiPicker(
                context,
                title: '选择时间',
                data: timeData,
                selectData: timeData2Select,
                suffix: ['年', '月'],
                onConfirm: onchange,
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 3, right: 3),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                  child: Row(children: [
                Text(
                  _mineWorkCommon.beginTime,
                  style: const TextStyle(fontSize: 12),
                ),
                const Icon(
                  Icons.expand_more,
                  size: 20,
                )
              ])),
            ),
          )
        ],
      ),
    );
  }

  late StateSetter tabBarSetter;

  Widget _tabBarView() {
    return Expanded(
        child: TabBarView(controller: _tabController, children: [
      MineFireListMain(
        present: _mineWorkCommon,
        userId: widget.id,
      ),
      MineAlarmListMain(
        present: _mineWorkCommon,
        userId: widget.id,
      ),
      MineInspectionListMain(
        present: _mineWorkCommon,
        userId: widget.id,
      ),
      MineTroubleListMain(
        present: _mineWorkCommon,
        userId: widget.id,
      ),
      MineDangerListMain(
        present: _mineWorkCommon,
        userId: widget.id,
      ),
    ]));
  }
}
