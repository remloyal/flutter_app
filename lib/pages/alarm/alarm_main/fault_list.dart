import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/button_group.dart';

class FaultList extends StatefulWidget {
  const FaultList({Key? key}) : super(key: key);

  @override
  State<FaultList> createState() => _FaultListState();
}

class _FaultListState extends State<FaultList> {
  final FaultParams _alarmParam = FaultParams();
  @override
  Widget build(BuildContext context) {
    return LoadList(
        api: AlarmApi.useFaultList,
        param: _alarmParam,
        precedent: FaultCase(),
        setTtem: _setTtem,
        header: _header);
  }

  _header(fire) {
    return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: ButtonGroup(
                names: const ['告警中', '已复位'],
                height: 30,
                onTap: (index) {
                  print(index);
                  if (index == 0) {
                    setState(() {
                      _alarmParam.status = 0;
                    });
                  }
                  if (index == 1) {
                    setState(() {
                      _alarmParam.status = 1;
                    });
                  }
                  _alarmParam.change();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    '共 ${fire.totalRow ?? 0} 条',
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            IconData(0xe628, fontFamily: 'fcm'),
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 18,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text('筛选'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  _setTtem(item) {
    return InkWell(
      onTap: () {
        print('${item}');
        // _refresh();
      },
      child: CardParent(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    const IconData(0xe612, fontFamily: 'fcm'),
                    color: item.status == 0
                        ? const Color(0xffFF9800)
                        : const Color(0xffcccccc),
                    size: 16,
                  ),
                ),
                if (item.status == 0 && item.confirmResult == 0)
                  const Text(
                    '设备故障',
                    style: TextStyle(fontSize: 14),
                  ),
                if (item.status == 1)
                  const Text(
                    '故障复位',
                    style: TextStyle(fontSize: 14),
                  ),
                if (item.status == 0 && item.confirmResult != 0)
                  const Text(
                    '报警确认',
                    style: TextStyle(fontSize: 14),
                  ),
              ],
            ),
            Row(
              children: [
                Icon(
                  const IconData(0xe806, fontFamily: 'fcm'),
                  color: item.status == 0
                      ? const Color(0xff1976D2)
                      : const Color(0xff4CAF50),
                  size: 16,
                ),
                Text(
                  item.status == 0
                      ? formatDurationByStart(item.startTime) ?? '-'
                      : formatDuration(item.startTime, item.resetTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: item.status == 0
                        ? const Color(0xff1976D2)
                        : const Color(0xff4CAF50),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            XfItem(
              label: '单位名称',
              content: item.unitName,
            ),
            XfItem(
              label: '发生位置',
              content:
                  formatStrWithDefault(item.buildingName, defaultValueOutdoor) +
                      ' ' +
                      formatStr(item.floorNumber) +
                      ' ' +
                      formatStr(item.roomNumber),
            ),
            XfItem(
              label: '告警设备',
              content: item.deviceName,
            ),
            XfItem(
              label: '告警事件',
              content: item.eventTypeContent,
              contentWidget: Row(children: [
                Text(
                  item.eventTypeContent,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.only(
                      left: 6, right: 6, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xffFFEBEE),
                      border: Border.all(color: Colors.red, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    '${item.eventCount}次',
                    style: const TextStyle(fontSize: 10, color: Colors.red),
                  ),
                )
              ]),
            ),
          ],
        ),
        fotter: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  IconData(0xe997, fontFamily: 'fcm'),
                  color: Color(0xff999999),
                  size: 16,
                ),
                Text(
                  item.startTime,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xff999999)),
                ),
              ],
            ),
            if (item.status == 1)
              Row(
                children: [
                  const Icon(
                    IconData(0xe66a, fontFamily: 'fcm'),
                    color: Color(0xff999999),
                    size: 16,
                  ),
                  Text(
                    item.resetTime,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                ],
              ),
            if (item.status == 0 && item.confirmResult != 0)
              Row(
                children: [
                  const Icon(
                    IconData(0xe6c5, fontFamily: 'fcm'),
                    color: Color(0xff999999),
                    size: 16,
                  ),
                  Text(
                    item.confirmTime,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
