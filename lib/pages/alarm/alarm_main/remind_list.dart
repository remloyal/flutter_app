import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/utils/alarm_tool.dart';

class ReminfList extends StatefulWidget {
  const ReminfList({Key? key}) : super(key: key);

  @override
  State<ReminfList> createState() => _ReminfListState();
}

class _ReminfListState extends State<ReminfList> {
  final ReminfParams _alarmParam = ReminfParams();
  @override
  Widget build(BuildContext context) {
    return LoadList(
        api: AlarmApi.useRemindList,
        param: _alarmParam,
        precedent: ReminfCase(),
        setTtem: _setTtem,
        header: _header);
  }

  _header(fire) {
    return SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '共 ${fire.totalRow ?? 0} 条',
                style: const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
              ),
              InkWell(
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
              )
            ],
          ),
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
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    IconData(0xe6d1, fontFamily: 'fcm'),
                    color: Color(0xffFFCC80),
                    size: 16,
                  ),
                ),
                Text(
                  getRemindTypeDesc(item.type),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  IconData(0xe897, fontFamily: 'fcm'),
                  color: Color(0xff999999),
                  size: 16,
                ),
                Text(
                  formatTime(item.happenTime).toString().split('.')[0],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff999999),
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
              label: '告警来源',
              content: item.source,
            ),
            XfItem(
              label: '提醒内容',
              content: item.content,
            )
          ],
        ),
      ),
    );
  }
}