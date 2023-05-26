import 'package:fire_control_app/pages/home/find_device_page.dart';
import 'package:fire_control_app/pages/home/home_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import '../../states/unit_model.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/http/home_api.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final Params _alarmStatsParam = Params();
  final Params _inspectStatsParam = Params();
  final DeviceParams _deviceStatsParam = DeviceParams();
  late AlarmStats _alarmStats =
      AlarmStats(alarm: 0, danger: 0, trouble: 0, fault: 0, fire: 0, risk: 0);

  late InspectStats _inspectStats = InspectStats(
      completionRate: '0',
      ratedTasks: 0,
      completionTasks: 0,
      inspectNumber: 0,
      inspectRoutes: 0);

  late DeviceStats _deviceStats = DeviceStats(
      total: 0,
      onlineRate: '0',
      online: 0,
      offline: 0,
      abnormalRate: '0',
      normal: 0,
      abnormal: 0);

  final List date = [1, 7, 30];
  // late Params unitId;
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    init();
    print('刷新数据');
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    alarmInit();
    inspectInit();
    deviceInit();
  }

  void alarmInit() async {
    var data = await HomeApi.useAlarmStats(_alarmStatsParam);
    setState(() {
      _alarmStats = data;
    });
  }

  void inspectInit() async {
    var data = await HomeApi.useInspectStats(_inspectStatsParam);
    print(data.toString());
    setState(() {
      _inspectStats = data;
    });
  }

  void deviceInit() async {
    var data = await HomeApi.useDeviceStats(_deviceStatsParam);
    setState(() {
      _deviceStats = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        // enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
            child: Consumer<UnitModel>(builder: (ctx, unit, child) {
          if (unit.unit != null) {
            if (unit.unit?.unitId != _alarmStatsParam.unitId) {
              _alarmStatsParam.unitId = unit.unit?.unitId;
              _inspectStatsParam.unitId = unit.unit?.unitId;
              _deviceStatsParam.unitId = unit.unit?.unitId;
              init();
            }
          }
          return KeepAliveWrapper(
              child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              head(),
              alarmStatistics(),
              patrolStatistics(),
              deviceStatistics()
            ],
          ));
        })));
  }

  onTop() {
    print('object');
  }

  head() {
    List<Map> listItem = [
      {
        'text': '查找设备',
        "color": const Color(0xff1976D2),
        "bgColor": const Color(0xffBBDEFB),
        'onTap': () {
          Navigator.pushNamed(context, FindDevicePage.routeName);
        },
        "iconData": const IconData(0xe623, fontFamily: 'fcm'),
      },
      {
        'text': '立即上报',
        "color": const Color(0xffFF9800),
        "bgColor": const Color(0xffFFE0B2),
        'onTap': () {
          Navigator.pushNamed(context, HomeReport.routeName);
        },
        "iconData": const IconData(0xe625, fontFamily: 'fcm'),
      },
      {
        'text': '一键119',
        "color": const Color(0xffE53935),
        "bgColor": const Color(0xffFFCDD2),
        'onTap': onTop,
        "iconData": const IconData(0xe66c, fontFamily: 'fcm'),
      },
      {
        'text': '通讯录',
        "color": const Color(0xffFF5722),
        "bgColor": const Color(0xffFFCCBC),
        'onTap': () {
          Navigator.pushNamed(
            context,
            '/mineMail',
          );
        },
        "iconData": const IconData(0xe7de, fontFamily: 'fcm'),
      }
    ];
    return Container(
        color: FcColor.cardColor,
        padding: const EdgeInsets.all(10),
        child: Flex(
            direction: Axis.horizontal,
            children: listItem.map((data) {
              return Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: data['onTap'],
                        child: Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                              color: data['bgColor'],
                              // border:
                              //     Border(left: BorderSide(width: 1, color: Colors.red)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(35))),
                          child: Icon(
                            data['iconData'],
                            color: data['color'],
                            size: 34,
                          ),
                        ),
                      ),
                      Text(data['text'])
                    ],
                  ));
            }).toList()));
  }

  // 告警统计
  alarmStatistics() {
    final List alarms = [
      {
        'name': '火情',
        'icon': const IconData(0xe66c, fontFamily: 'fcm'),
        'amount': _alarmStats.fire,
        'color': const Color(0xffE53935),
        'type': 'fire',
      },
      {
        'name': '报警',
        'icon': const IconData(0xe6d3, fontFamily: 'fcm'),
        'amount': _alarmStats.alarm,
        'color': const Color(0xffFD9B88),
        'type': 'alarm',
      },
      {
        'name': '故障',
        'icon': const IconData(0xe612, fontFamily: 'fcm'),
        'amount': _alarmStats.fault,
        'color': const Color(0xffFFB317),
        'type': 'fault',
      },
      {
        'name': '隐患',
        'icon': const IconData(0xe637, fontFamily: 'fcm'),
        'amount': _alarmStats.trouble,
        'color': const Color(0xffFFB317),
        'type': 'trouble',
      },
      {
        'name': '危险品',
        'icon': const IconData(0xe69d, fontFamily: 'fcm'),
        'amount': _alarmStats.danger,
        'color': const Color(0xffFD9B88),
        'type': 'danger',
      },
      {
        'name': '风险',
        'icon': const IconData(0xe627, fontFamily: 'fcm'),
        'amount': _alarmStats.risk,
        'color': const Color(0xff1994DE),
        'type': 'risk',
      },
    ];
    return CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 20,
              color: FcColor.baseColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('告警统计'),
          ),
          ButtonGroup(
            names: const ['今日', '本周', '本月'],
            height: 30,
            onTap: (index) {
              _alarmStatsParam.type = date[index];
              print(_alarmStatsParam.type);
              // _onRefresh();
              alarmInit();
            },
          ),
        ]),
        body: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                ...alarms.sublist(0, 3).map((data) {
                  return Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10),
                        // margin: const EdgeInsets.all(4),
                        color: const Color(0xffF5F5F5),
                        child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                data['icon'],
                                color: data['color'],
                                size: 30,
                              ),
                              Column(children: [
                                Text(
                                  data['amount'].toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: data['color'],
                                  ),
                                ),
                                Text(
                                  data['name'],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    // color: data['color'],
                                  ),
                                ),
                              ])
                            ]),
                      ));
                }).toList()
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                ...alarms.sublist(3, 6).map((data) {
                  return Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        // margin: const EdgeInsets.all(4),
                        color: const Color(0xffF5F5F5),
                        child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                data['icon'],
                                color: data['color'],
                                size: 30,
                              ),
                              Column(children: [
                                Text(
                                  data['amount'].toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: data['color'],
                                  ),
                                ),
                                Text(
                                  data['name'],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    // color: data['color'],
                                  ),
                                ),
                              ])
                            ]),
                      ));
                }).toList()
              ],
            )
          ],
        )
        // Wrap(
        //   spacing: 6, //主轴上子控件的间距
        //   runSpacing: 6, //交叉轴上子控件之间的间距
        //   runAlignment: WrapAlignment.start,
        //   children: [
        //     ...alarms.map((data) {
        //       return Container(
        //         // height: 80,
        //         width: 100,
        //         padding: const EdgeInsets.all(10),
        //         // margin: const EdgeInsets.all(4),
        //         color: const Color(0xffF5F5F5),
        //         child: Flex(
        //             direction: Axis.horizontal,
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               Icon(
        //                 data['icon'],
        //                 color: data['color'],
        //                 size: 30,
        //               ),
        //               Column(children: [
        //                 Text(
        //                   '2',
        //                   textAlign: TextAlign.right,
        //                   style: TextStyle(
        //                     fontSize: 20,
        //                     color: data['color'],
        //                   ),
        //                 ),
        //                 Text(
        //                   data['name'],
        //                   textAlign: TextAlign.right,
        //                   style: const TextStyle(
        //                     fontSize: 12,
        //                     // color: data['color'],
        //                   ),
        //                 ),
        //               ])
        //             ]),
        //       );
        //     }).toList()
        //   ], //要显示的子控件集合
        // )
        );
  }

  // 巡检统计
  patrolStatistics() {
    return CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 20,
              color: FcColor.baseColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('巡检统计'),
          ),
          ButtonGroup(
            names: const ['今日', '本周', '本月'],
            height: 30,
            onTap: (index) {
              print(index);
              _inspectStatsParam.type = date[index];
              inspectInit();
              // if (index == 1) {
              //   _param.status = 2;
              // } else {
              //   _param.status = 1;
              // }
              // _onRefresh();
            },
          ),
        ]),
        body: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: 70,
                height: 70,
                // margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.only(top: 14),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 212, 248, 215),
                    // border:
                    //     Border(left: BorderSide(width: 1, color: Colors.red)),
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: Column(children: [
                  Text(
                    '${_inspectStats.completionRate}%',
                    style: const TextStyle(color: Color(0xff4CAF50)),
                  ),
                  const Text(
                    '完成率',
                    style: TextStyle(color: Color(0xff4CAF50)),
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: const [
                  Text(
                    '额定任务',
                    style: TextStyle(
                        fontSize: 14,
                        height: 2,
                        color: Color.fromARGB(255, 126, 126, 126)),
                  ),
                  Text('完成任务',
                      style: TextStyle(
                          fontSize: 14,
                          height: 2,
                          color: Color.fromARGB(255, 126, 126, 126))),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _inspectStats.ratedTasks.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        height: 2,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(_inspectStats.completionTasks.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          height: 2,
                          color: Color.fromARGB(255, 0, 0, 0))),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: const [
                  Text(
                    '巡检路线',
                    style: TextStyle(
                        fontSize: 14,
                        height: 2,
                        color: Color.fromARGB(255, 126, 126, 126)),
                  ),
                  Text('巡检人数',
                      style: TextStyle(
                          fontSize: 14,
                          height: 2,
                          color: Color.fromARGB(255, 126, 126, 126))),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _inspectStats.inspectRoutes.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        height: 2,
                        color: Color.fromARGB(255, 255, 0, 0)),
                  ),
                  Text(_inspectStats.inspectNumber.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          height: 2,
                          color: Color.fromARGB(255, 255, 0, 0))),
                ],
              ),
            ),
          ],
        ));
  }

  //设备统计
  deviceStatistics() {
    return CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 20,
              color: FcColor.baseColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('设备统计'),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Text('${_deviceStats.total.toString()}个'),
          )
        ]),
        body: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      // margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.only(top: 14),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 212, 248, 215),
                          // border:
                          //     Border(left: BorderSide(width: 1, color: Colors.red)),
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Column(children: [
                        Text(
                          '${_deviceStats.onlineRate}%',
                          style: const TextStyle(color: Color(0xff4CAF50)),
                        ),
                        const Text(
                          '在线率',
                          style: TextStyle(color: Color(0xff4CAF50)),
                        ),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: const [
                          Text(
                            '在线',
                            style: TextStyle(
                                fontSize: 14,
                                height: 2,
                                color: Color.fromARGB(255, 126, 126, 126)),
                          ),
                          Text('离线',
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 2,
                                  color: Color.fromARGB(255, 126, 126, 126))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _deviceStats.online.toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff4CAF90)),
                        ),
                        Text(_deviceStats.offline.toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                height: 2,
                                color: Color.fromARGB(255, 255, 0, 0))),
                      ],
                    ),
                  ],
                )),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      // margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.only(top: 14),
                      decoration: const BoxDecoration(
                          color: Color(0xffFFEBEE),
                          // border:
                          //     Border(left: BorderSide(width: 1, color: Colors.red)),
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Column(children: [
                        Text('${_deviceStats.abnormalRate}%',
                            style: const TextStyle(color: Color(0xffE53935))),
                        const Text(
                          '异常率',
                          style: TextStyle(color: Color(0xffE53935)),
                        ),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: const [
                          Text(
                            '正常',
                            style: TextStyle(
                                fontSize: 14,
                                height: 2,
                                color: Color.fromARGB(255, 126, 126, 126)),
                          ),
                          Text('异常',
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 2,
                                  color: Color.fromARGB(255, 126, 126, 126))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _deviceStats.normal.toString(),
                          style: const TextStyle(
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff4CAF90)),
                        ),
                        Text(_deviceStats.abnormal.toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                height: 2,
                                color: Color.fromARGB(255, 255, 0, 0))),
                      ],
                    ),
                  ],
                )),
          ],
        ));
  }
}
