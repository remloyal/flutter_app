import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fire_control_app/common/colors.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/button_group.dart';

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
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    items = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
    ];
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {});
    }
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        // enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        // onLoading: _onLoading,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              head(),
              alarmStatistics(),
              patrolStatistics(),
              deviceStatistics()
            ],
          ),
        ));
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
        'onTap': onTop,
        "iconData": const IconData(0xe623, fontFamily: 'fcm'),
      },
      {
        'text': '立即上报',
        "color": const Color(0xffFF9800),
        "bgColor": const Color(0xffFFE0B2),
        'onTap': onTop,
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
        'onTap': onTop,
        "iconData": const IconData(0xe7de, fontFamily: 'fcm'),
      }
    ];
    return Container(
        color: FireControlColor.cardColor,
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
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                              color: data['bgColor'],
                              // border:
                              //     Border(left: BorderSide(width: 1, color: Colors.red)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40))),
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
    final Map alarmStats = {'fire': ''};
    final List alarms = [
      {
        'name': '火情',
        'icon': const IconData(0xe66c, fontFamily: 'fcm'),
        'amount': alarmStats['fire'],
        'color': const Color(0xffE53935),
        'type': 'fire',
      },
      {
        'name': '报警',
        'icon': const IconData(0xe6d3, fontFamily: 'fcm'),
        'amount': alarmStats['alarm'],
        'color': const Color(0xffFD9B88),
        'type': 'alarm',
      },
      {
        'name': '故障',
        'icon': const IconData(0xe612, fontFamily: 'fcm'),
        'amount': alarmStats['fault'],
        'color': const Color(0xffFFB317),
        'type': 'fault',
      },
      {
        'name': '隐患',
        'icon': const IconData(0xe637, fontFamily: 'fcm'),
        'amount': alarmStats['trouble'],
        'color': const Color(0xffFFB317),
        'type': 'trouble',
      },
      {
        'name': '危险品',
        'icon': const IconData(0xe69d, fontFamily: 'fcm'),
        'amount': alarmStats['danger'],
        'color': const Color(0xffFD9B88),
        'type': 'danger',
      },
      {
        'name': '风险',
        'icon': const IconData(0xe627, fontFamily: 'fcm'),
        'amount': alarmStats['risk'],
        'color': const Color(0xff1994DE),
        'type': 'risk',
      },
    ];
    return CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 20,
              color: FireControlColor.baseColor,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('告警统计'),
          ),
          ButtonGroup(
            names: const ['今日', '本周', '本月'],
            height: 30,
            onTap: (index) {
              print(index);
              // if (index == 1) {
              //   _param.status = 2;
              // } else {
              //   _param.status = 1;
              // }
              // _onRefresh();
            },
          ),
        ]),
        body: Wrap(
          spacing: 6, //主轴上子控件的间距
          runSpacing: 6, //交叉轴上子控件之间的间距
          runAlignment: WrapAlignment.start,
          children: [
            ...alarms.map((data) {
              return Container(
                // height: 50,
                width: 114,
                padding: const EdgeInsets.all(10),
                // margin: const EdgeInsets.all(4),
                color: const Color(0xffF5F5F5),
                child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          data['icon'],
                          color: data['color'],
                          size: 34,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(children: [
                            Text(
                              '2',
                              style: TextStyle(
                                fontSize: 24,
                                color: data['color'],
                              ),
                            ),
                            Text(data['name']),
                          ])),
                    ]),
              );
            }).toList()
          ], //要显示的子控件集合
        ));
  }

  // 巡检统计
  patrolStatistics() {
    return CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 20,
              color: FireControlColor.baseColor,
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
                child: Column(children: const [
                  Text(
                    '22%',
                    style: TextStyle(color: Color(0xff4CAF50)),
                  ),
                  Text(
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
                children: const [
                  Text(
                    '524',
                    style: TextStyle(
                        fontSize: 14,
                        height: 2,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text('0',
                      style: TextStyle(
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
                children: const [
                  Text(
                    '524',
                    style: TextStyle(
                        fontSize: 14,
                        height: 2,
                        color: Color.fromARGB(255, 255, 0, 0)),
                  ),
                  Text('0',
                      style: TextStyle(
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
              color: FireControlColor.baseColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('设备统计'),
          ),
          // ButtonGroup(
          //   names: const ['今日', '本周', '本月'],
          //   height: 30,
          //   onTap: (index) {
          //     print(index);
          //     // if (index == 1) {
          //     //   _param.status = 2;
          //     // } else {
          //     //   _param.status = 1;
          //     // }
          //     // _onRefresh();
          //   },
          // ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: const Text('79576个'),
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
                      child: Column(children: const [
                        Text(
                          '22%',
                          style: TextStyle(color: Color(0xff4CAF50)),
                        ),
                        Text(
                          '完成率',
                          style: TextStyle(color: Color(0xff4CAF50)),
                        ),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 20),
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
                      children: const [
                        Text(
                          '524',
                          style: TextStyle(
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff4CAF90)),
                        ),
                        Text('0',
                            style: TextStyle(
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
                      child: Column(children: const [
                        Text('22%', style: TextStyle(color: Color(0xffE53935))),
                        Text(
                          '异常率',
                          style: TextStyle(color: Color(0xffE53935)),
                        ),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 20),
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
                      children: const [
                        Text(
                          '524',
                          style: TextStyle(
                              fontSize: 14,
                              height: 2,
                              color: Color(0xff4CAF90)),
                        ),
                        Text('0',
                            style: TextStyle(
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
