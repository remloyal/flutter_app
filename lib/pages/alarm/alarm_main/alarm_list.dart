import 'package:fire_control_app/pages/alarm/alarm_filter.dart';
import 'package:fire_control_app/pages/alarm/details/alarm_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/button_group.dart';

class AlarmList extends StatefulWidget {
  const AlarmList({Key? key}) : super(key: key);

  @override
  State<AlarmList> createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> with ListBuilder<AlarmItem> {
  final AlarmParam _alarmParam = AlarmParam();

  @override
  Widget build(BuildContext context) {
    return LoadList<AlarmApi, AlarmParam>(
        api: AlarmApi(), param: _alarmParam, listBuilder: this);
  }

  @override
  Widget? buildToolbar(BuildContext context, int total) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ButtonGroup(
                names: const ['告警中', '已关闭'],
                height: 30,
                onTap: (index) {
                  _alarmParam.status = index;
                  _alarmParam.change();
                },
              ),
            ),
            Text(
              '共 $total 条',
              style: const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
            ),
            AlarmFaultFilter(
              param: _alarmParam,
            )
          ],
        ));
  }

  @override
  Widget buildItem(BuildContext context, AlarmItem item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AlarmDetailPage.routeName,
            arguments: item.id);
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
                    const IconData(0xe638, fontFamily: 'fcm'),
                    color: item.status == 1
                        ? const Color(0xffcccccc)
                        : item.status == 0 && item.confirmResult != 0
                            ? const Color(0xff1976D2)
                            : const Color(0xffE53935),
                    size: 16,
                  ),
                ),
                if (item.status == 0 && item.confirmResult == 0)
                  const Text(
                    '设备报警',
                    style: TextStyle(fontSize: 14),
                  ),
                if (item.status == 1)
                  const Text(
                    '报警复位',
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
                    item.resetTime ?? '-',
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
                    item.confirmTime ?? '-',
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
