import 'package:fire_control_app/pages/alarm/alarm_filter.dart';
import 'package:fire_control_app/pages/alarm/details/danger_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/button_group.dart';

class DangerList extends StatelessWidget {

  final DangerParam _alarmParam;

  DangerList({super.key}) : _alarmParam = DangerParam();


  @override
  Widget build(BuildContext context) {
    return LoadList<DangerApi, DangerParam, DangerItem>(
      api: DangerApi(),
      param: _alarmParam,
      toolbarBuilder: _buildToolbar,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildToolbar(BuildContext context, int total) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ButtonGroup(
                names: const ['待处理', '已处理'],
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
            DangerFilter(
              param: _alarmParam,
            )
          ],
        ));
  }

  Widget _buildItem(BuildContext context, DangerItem item, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, DangerDetailPage.routeName,
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
                    const IconData(0xe69d, fontFamily: 'fcm'),
                    color: item.status == 0
                        ? const Color(0xffFF9800)
                        : const Color(0xffcccccc),
                    size: 16,
                  ),
                ),
                Text(
                  item.status == 0 ? '发现危险品' : '危险品已处理',
                  style: const TextStyle(fontSize: 14),
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
                      ? formatDurationByStart(item.createTime) ?? '-'
                      : formatDuration(item.createTime, item.reviewTime),
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
              label: '危险类型',
              contentWidget: Text(
                item.dangerTypeName,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
            XfItem(
              label: '事件描述',
              content: item.cont,
            ),
            if (item.status == 1)
              XfItem(
                label: '处理描述',
                content: item.treatment,
              ),
            XfItem(
              label: item.status == 0 ? '上报人员' : '处理人员',
              contentWidget: Row(children: [
                Text(
                  item.nickName ?? '-',
                  style: const TextStyle(fontSize: 12),
                ),
                if (item.phone != null)
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.only(
                        left: 6, right: 6, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xffE3F2FD),
                        border: Border.all(
                            color: const Color(0xff1976D2), width: 0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_phone,
                          color: Color(0xff1976D2),
                          size: 10,
                        ),
                        Text(
                          '${item.phone}',
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xff1976D2)),
                        ),
                      ],
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
                  item.createTime,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xff999999)),
                ),
              ],
            ),
            if (item.status == 1)
              Row(
                children: [
                  const Icon(
                    IconData(0xe6c5, fontFamily: 'fcm'),
                    color: Color(0xff999999),
                    size: 16,
                  ),
                  Text(
                    item.reviewTime,
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
