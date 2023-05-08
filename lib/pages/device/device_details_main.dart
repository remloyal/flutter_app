import 'package:fire_control_app/common/fc_color.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/pages/device/device_details/device_details_event.dart';
import 'package:fire_control_app/pages/device/device_details/device_details_info.dart';
import 'package:fire_control_app/pages/device/device_details/device_details_operation_log.dart';
import 'package:fire_control_app/pages/device/device_details/device_details_real_time.dart';
import 'package:fire_control_app/utils/toast.dart';

class DeviceDetailsMain extends StatefulWidget {
  const DeviceDetailsMain({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DeviceDetailsMain> createState() => _DeviceDetailsMainState();
}

class _DeviceDetailsMainState extends State<DeviceDetailsMain>
    with SingleTickerProviderStateMixin {
  DeviceDetails? _details;
  late bool loadingState = false;
  TabController? _tabController;
  GlobalKey _operationLogKey = GlobalKey();

  @override
  void initState() {
    _init();
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _init() async {
    _details = await DeviceApi.useDeviceDetails(widget.deviceId);
    loadingState = true;
    Future.delayed(const Duration(milliseconds: 200)).then((e) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '设备详情',
      footer: _tabController!.index == 3
          ? [
              Expanded(
                flex: 2,
                child: LocationButton(
                  text: _details!.stop == 1 ? '解封' : '封停',
                  onPressed: () {
                    if (_details!.stop == 1) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("提示"),
                            content: const Text("确认解封？"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("取消"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    _unblock();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("确定",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ))),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return closure();
                          });
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: HandleButton(title: '操作指令', onPressed: () {}),
              ),
            ]
          : null,
      loadingState: loadingState,
      roll: false,
      body:
          loadingState == false ? [] : [..._detailsTitle(), ..._detailsBody()],
      actions: [
        IconButton(
          onPressed: () {
            print('object');
          },
          icon: const Icon(
            IconData(0xe60B, fontFamily: 'fcm'),
            size: 22,
          ),
        ),
      ],
    );
  }

  List<Widget> _detailsTitle() {
    return [
      Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    IconData(0xe6bd, fontFamily: 'fcm'),
                    color: Colors.red,
                    size: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      _details!.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
              if (_details!.deviceTypeId == 7 ||
                  _details!.deviceTypeId == 242 ||
                  _details!.deviceTypeId == 243)
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      IconData(0xe65c, fontFamily: 'fcm'),
                      color: Colors.white,
                      size: 14,
                    ),
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(60, 30)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color.fromARGB(255, 0, 88, 160);
                          }
                          return const Color(0XFF1976D2);
                        }),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                top: 2, bottom: 2, left: 6, right: 6))),
                    label: const Text(
                      "查看监控",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ))
            ],
          )),
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              DeviceTag(
                text: _details!.deviceTypeName,
                bgColor: const Color(0xFFEEEEEE),
                borderColor: const Color(0xFF000000),
              ),
              if (_details!.alarm == 0 && _details!.fault == 0)
                const DeviceTag(
                  text: '正常',
                  textColor: Color(0xFF7CC57F),
                  bgColor: Color(0xFFE8F5E9),
                  borderColor: Color(0xFF7CC57F),
                  icon: Icon(
                    IconData(0xe60d, fontFamily: 'fcm'),
                    color: Color(0xFF7CC57F),
                    size: 14,
                  ),
                ),
              if (_details!.alarm > 0)
                DeviceTag(
                  text: _details!.alarm.toString(),
                  fontSize: 16,
                  textColor: const Color(0xFFE53935),
                  bgColor: const Color(0xFFFFEBEE),
                  borderColor: const Color(0xFFE53935),
                  icon: const Icon(
                    IconData(0xe6d3, fontFamily: 'fcm'),
                    color: Color(0xFFE53935),
                    size: 14,
                  ),
                ),
              if (_details!.fault > 0)
                DeviceTag(
                  text: _details!.fault.toString(),
                  fontSize: 16,
                  textColor: const Color(0xFFFF9800),
                  bgColor: const Color(0xFFFFF3E0),
                  borderColor: const Color(0xFFFF9800),
                  icon: const Icon(
                    IconData(0xe612, fontFamily: 'fcm'),
                    color: Color(0xFFFF9800),
                    size: 14,
                  ),
                ),
            ],
          ),
          if (_details!.online == 1)
            const DeviceTag(
              text: '未上线',
              fontSize: 14,
              textColor: Color.fromARGB(255, 148, 148, 148),
              bgColor: Color(0xFFDBDBDB),
              borderColor: Color(0xFFDBDBDB),
            ),
          if (_details!.online == 2)
            const DeviceTag(
              text: '在线',
              textColor: Color(0xFFFFFFFF),
              bgColor: Color(0xFF4CAF50),
              borderColor: Color(0xFF4CAF50),
            ),
          if (_details!.online == 3)
            const DeviceTag(
              text: '离线',
              fontSize: 14,
              textColor: Color(0xFFFFEBEE),
              bgColor: Color(0xFFE53935),
              borderColor: Color(0xFFE53935),
            ),
        ]),
      )
    ];
  }

  List<Widget> _detailsBody() {
    return [
      Container(
        margin: const EdgeInsets.only(top: 10),
        color: FcColor.cardColor,
        width: MediaQuery.of(context).size.width,
        child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: Colors.red,
            dividerColor: const Color.fromARGB(255, 245, 0, 0),
            indicatorColor: Colors.red,
            unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
            indicatorWeight: 2,
            tabs: [
              ...['告警提醒', '实时数据', '设备信息', '操作记录'].map((item) {
                return Tab(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ]),
      ),
      Expanded(
        child: TabBarView(controller: _tabController, children: [
          DetailsEvent(
            deviceId: widget.deviceId,
          ),
          DetailsRealTime(
            deviceId: widget.deviceId,
          ),
          DetailsInfo(
            device: _details!,
          ),
          DetailsOperationLog(
            key: _operationLogKey,
            deviceId: widget.deviceId,
          )
        ]),
      ),
    ];
  }

  // 设备封停
  int checked = 1;
  late String checkVal = '';
  List typeList = [
    {'type': 1, 'name': '损坏'},
    {'type': 2, 'name': '施工'},
    {'type': 3, 'name': '停用'},
    {'type': 4, 'name': '其它'}
  ];
  final TextEditingController _textEditingController = TextEditingController();
  _setCheckVal() {
    for (var i = 0; i < typeList.length; i++) {
      if (typeList[i]['type'] == checked) {
        checkVal = typeList[i]['name'];
      }
    }
  }

  _setDevicStop() {
    if (checkVal == '') {
      Message.error('请填写原因');
      return;
    }

    DeviceApi.setDevicStop(widget.deviceId, type: checked, reason: checkVal)
        .then((value) {
      if (value['code'] == 200) {
        Message.show('封停成功');
        setState(() {
          _operationLogKey = GlobalKey();
          _details!.stop = 1;
        });
      }
    });
  }

  // 解封
  _unblock() {
    DeviceApi.setDevicStart(widget.deviceId).then((value) {
      if (value['code'] == 200) {
        Message.show('解封成功');
        setState(() {
          _operationLogKey = GlobalKey();
          _details!.stop = 0;
        });
      }
    });
  }

  Widget closure() {
    checked = 1;
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              height: checked == 4 ? 340 : 330,
              child: Column(children: [
                const Center(
                  child: Text(
                    '选择原因',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const Divider(
                  indent: 0.0,
                  color: Color.fromARGB(255, 190, 190, 190),
                ),
                ...typeList.map((res) {
                  return RadioListTile<int>(
                      value: res['type'],
                      groupValue: checked,
                      title: Text(res['name']),
                      dense: true,
                      contentPadding: EdgeInsets.all(0.5),
                      onChanged: (value) {
                        setState(() {
                          checked = value!;
                        });
                        _setCheckVal();
                      });
                }).toList(),
                if (checked == 4)
                  TextField(
                    controller: _textEditingController,
                    style: const TextStyle(fontSize: 12),
                    scrollPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: const InputDecoration(
                      filled: true,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      border: OutlineInputBorder(),
                      hintText: '请填写原因',
                    ),
                    onChanged: (value) {
                      checkVal = value;
                    },
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 0, 0, 0)),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFEEEEEE)),
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        onPressed: () {
                          // widget.onChange(_deviceParam);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            color: Color(0xFF9D9D9D),
                            fontSize: 14,
                          ),
                        )),
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 0, 0, 0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 15)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        onPressed: () {
                          // widget.onChange(_deviceParam);
                          _setDevicStop();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '确定',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                          ),
                        )),
                  ],
                )
              ])));
    });
  }
}

class DeviceTag extends StatelessWidget {
  const DeviceTag(
      {super.key,
      required this.text,
      required this.bgColor,
      required this.borderColor,
      this.icon,
      this.textColor,
      this.fontSize});
  final String text;
  final Color? textColor;
  final double? fontSize;
  final Color bgColor;
  final Color borderColor;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 1, right: 1),
        padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 0.5),
          borderRadius: BorderRadius.circular((12)),
        ),
        child: icon != null
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    child: icon,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: fontSize ?? 12,
                        color: textColor ?? const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                    fontSize: fontSize ?? 12,
                    color: textColor ?? const Color.fromARGB(255, 0, 0, 0)),
              ));
  }
}
