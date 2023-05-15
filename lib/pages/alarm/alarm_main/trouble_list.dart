import 'package:fire_control_app/pages/alarm/alarm_filter.dart';
import 'package:fire_control_app/pages/alarm/details/trouble_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/utils/alarm_tool.dart';

class TroubleList extends StatefulWidget {
  const TroubleList({Key? key}) : super(key: key);

  @override
  State<TroubleList> createState() => _TroubleListState();
}

class _TroubleListState extends State<TroubleList>
    with ListBuilder<TroubleItem> {
  final TroubleParam _alarmParam = TroubleParam();

  @override
  Widget build(BuildContext context) {
    return LoadList<TroubleApi, TroubleParam>(
        api: TroubleApi(), param: _alarmParam, listBuilder: this);
  }

  @override
  Widget? buildToolbar(BuildContext context, int total) {
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
            TroubleFilter(
              param: _alarmParam,
            )
          ],
        ));
  }

  @override
  Widget buildItem(BuildContext context, TroubleItem item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, TroubleDetailPage.routeName,
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
                    const IconData(0xe637, fontFamily: 'fcm'),
                    color: item.status == 0
                        ? const Color(0xffFF9800)
                        : const Color(0xffcccccc),
                    size: 16,
                  ),
                ),
                Text(
                  item.status == 0 ? '发现隐患' : '隐患已处理',
                  style: const TextStyle(fontSize: 14),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 1, bottom: 1),
                  decoration: BoxDecoration(
                      color: item.status == 1
                          ? const Color(0xffF5F5F5)
                          : item.levels == 1
                              ? const Color(0xffFFF8E1)
                              : item.levels == 2
                                  ? const Color(0xffFFF3E0)
                                  : const Color(0xffffebee),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          width: 0.5,
                          color: item.status == 1
                              ? const Color(0xffAAAAAA)
                              : item.levels == 1
                                  ? const Color(0xffFFB300)
                                  : item.levels == 2
                                      ? const Color(0xffFF9800)
                                      : const Color(0xffE53935))),
                  child: Text(
                    item.levels == 1
                        ? '低'
                        : item.levels == 2
                            ? '中'
                            : '高',
                    style: TextStyle(
                        fontSize: 12,
                        color: item.status == 1
                            ? const Color(0xffAAAAAA)
                            : item.levels == 1
                                ? const Color(0xffFFB300)
                                : item.levels == 2
                                    ? const Color(0xffFF9800)
                                    : const Color(0xffE53935)),
                  ),
                )
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
              label: '隐患类型',
              contentWidget: Text(
                getTroubleTypeDesc(item.type),
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
            XfItem(
              label: item.status == 1 ? '处理人员' : '上报人员',
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
                        border:
                            Border.all(color: Color(0xff1976D2), width: 0.5),
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
