import 'package:fire_control_app/pages/alarm/alarm_filter.dart';
import 'package:fire_control_app/pages/alarm/details/fire_detail_page.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/button_group.dart';

class FireList extends StatefulWidget {
  const FireList({Key? key}) : super(key: key);

  @override
  State<FireList> createState() => _FireListState();
}

class _FireListState extends State<FireList> with ListBuilder<FireItem> {
  final FireParam _fireParam = FireParam();

  @override
  Widget build(BuildContext context) {
    return LoadList<FireApi, FireParam>(
        api: FireApi(), param: _fireParam, listBuilder: this);
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
                  _fireParam.status = index;
                  _fireParam.change();
                },
              ),
            ),
            Text(
              '共 $total 条',
              style: const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
            ),
            FireFilter(
              param: _fireParam,
            )
          ],
        ));
  }

  @override
  Widget buildItem(BuildContext context, FireItem item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, FireDetailPage.routeName,
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
                    const IconData(0xe66c, fontFamily: 'fcm'),
                    color: item.status == 0
                        ? const Color(0xffE53935)
                        : const Color(0xff999999),
                    size: 16,
                  ),
                ),
                if (item.status == 0)
                  Text(
                    item.fireType == 1 ? '人员上报火情' : '确认设备报警',
                    style: const TextStyle(fontSize: 14),
                  )
                else
                  const Text(
                    '火情关闭',
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
                  formatDurationByStart(item.startTime) ?? '-',
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
            if (item.fireType != 1)
              XfItem(
                label: '告警设备',
                content: item.deviceName ?? '-',
              ),
            if (item.status == 0)
              XfItem(
                  label: item.fireType == 1 ? '上报人员' : '确认人员',
                  contentWidget: UserContent(
                    name: item.fireType == 3 ? '智能监控设备' : item.nickName ?? '-',
                    phone: item.phone,
                  )),
            if (item.status == 1)
              XfItem(
                  label: '关闭人员',
                  contentWidget: UserContent(
                    name: item.nickName,
                    phone: item.phone,
                  ))
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
                    IconData(0xe6ca, fontFamily: 'fcm'),
                    color: Color(0xff999999),
                    size: 16,
                  ),
                  Text(
                    item.endTime,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
