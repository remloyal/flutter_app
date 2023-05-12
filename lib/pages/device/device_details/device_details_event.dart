import 'package:fire_control_app/widgets/button_group.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:intl/intl.dart';

// 告警提醒
class DetailsEvent extends StatefulWidget {
  const DetailsEvent({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DetailsEvent> createState() => _DetailsEventState();
}

class _DetailsEventState extends State<DetailsEvent>
    with ListBuilder<DeviceEventItem> {
  late DeviceEventParams _deviceEventParam;
  @override
  void initState() {
    super.initState();
    setState(() {
      _deviceEventParam = DeviceEventParams(
        deviceId: widget.deviceId,
        type: 1,
      );
    });
  }

  @override
  Widget? buildToolbar(BuildContext context, int total) {
    return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: ButtonGroup(
                names: const ['报警', '故障', '提醒'],
                height: 30,
                onTap: (index) {
                  if (index == 0) {
                    setState(() {
                      _deviceEventParam.type = 1;
                    });
                  }
                  if (index == 1) {
                    setState(() {
                      _deviceEventParam.type = 0;
                    });
                  }
                  if (index == 2) {
                    setState(() {
                      _deviceEventParam.type = 5;
                    });
                  }
                  _deviceEventParam.change();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '共 $total 条',
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return LoadList<DeviceEventApi, DeviceEventParams>(
        api: DeviceEventApi(), param: _deviceEventParam, listBuilder: this);
  }

  @override
  Widget buildItem(BuildContext context, DeviceEventItem item) {
    return InkWell(
      highlightColor: Colors.amberAccent,
      onTap: () {
        if (_deviceEventParam.type == 1) {
          Navigator.pushNamed(context, '/alarmDetail', arguments: item.id);
        }
        if (_deviceEventParam.type == 0) {
          Navigator.pushNamed(context, '/faultDetail', arguments: item.id);
        }
      },
      child: _alarmLampItem(item),
    );
  }

  // 报警

  Widget _alarmLampItem(item) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      iconName(),
                      color: iconClass(item.status),
                      size: 18,
                    ),
                  ),
                  if (_deviceEventParam.type != 5)
                    Text('${item.eventTypeContent} ${item.eventCount ?? 0}次'),
                  if (_deviceEventParam.type == 5)
                    Text(setRemindType(item.type))
                ],
              ),
              if (_deviceEventParam.type == 5)
                Text(
                  '${setHappenTime(item.happenTime)}',
                  style:
                      const TextStyle(color: Color(0xFF999999), fontSize: 12),
                ),
            ],
          ),
          if (_deviceEventParam.type == 0 || _deviceEventParam.type == 1)
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '发生：${item.startTime}',
                    style:
                        const TextStyle(color: Color(0xFF999999), fontSize: 12),
                  ),
                  if (item.status == 1)
                    Text(
                      '复位：${item.resetTime ?? ''}',
                      style: const TextStyle(
                          color: Color(0xFF999999), fontSize: 12),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  iconClass(status) {
    if (status == 1) {
      return const Color(0xff4CAF50);
    } else if (_deviceEventParam.type == 1) {
      return const Color(0xffE53935);
    } else if (_deviceEventParam.type == 0) {
      return const Color(0xffFF9800);
    } else if (_deviceEventParam.type == 5) {
      return const Color(0xffFFB300);
    }
    return const Color(0xFF666666);
  }

  IconData iconName() {
    if (_deviceEventParam.type == 1) {
      return const IconData(0xe6d3, fontFamily: 'fcm');
    } else if (_deviceEventParam.type == 0) {
      return const IconData(0xe612, fontFamily: 'fcm');
    } else if (_deviceEventParam.type == 5) {
      return const IconData(0xe6d1, fontFamily: 'fcm');
    }
    return const IconData(0xe6d3, fontFamily: 'fcm');
  }

  setHappenTime(happenTime) {
    if (happenTime == null) {
      return '';
    }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      happenTime,
    );
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
  }

  final List<Map> remindTypes = [
    {'text': '全部类型', 'value': ''},
    {'text': '设备自检', 'value': 1},
    {'text': '设备布控', 'value': 2},
    {'text': '设备其他', 'value': 3},
    {'text': '设备消音', 'value': 4},
    {'text': '设备操作', 'value': 5},
    {'text': '设备离线', 'value': 6},
  ];

  setRemindType(type) {
    for (var i = 0; i < remindTypes.length; i++) {
      if (remindTypes[i]['value'] == type) {
        return remindTypes[i]['text'];
      }
    }
    return '';
  }
}
