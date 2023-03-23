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

class _FireListState extends State<FireList> {
  final FireParams _fireParam = FireParams();

  @override
  Widget build(BuildContext context) {
    return LoadList(
        api: AlarmApi.useFireList,
        param: _fireParam,
        precedent: FireCase(),
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
                names: const ['告警中', '已关闭'],
                height: 30,
                onTap: (index) {
                  print(index);
                  if (index == 0) {
                    setState(() {
                      _fireParam.status = 0;
                    });
                  }
                  if (index == 1) {
                    setState(() {
                      _fireParam.status = 1;
                    });
                  }
                  _fireParam.change();
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
                contentWidget: Row(children: [
                  Text(
                    item.fireType == 3 ? '智能监控设备' : item.nickName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (item.phone != null)
                    InkWell(
                      child: Text(
                        item.phone,
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                ]),
              ),
            if (item.status == 1)
              XfItem(
                label: '关闭人员',
                contentWidget: Row(children: [
                  Text(
                    item.nickName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (item.phone != null)
                    InkWell(
                      child: Text(
                        item.phone,
                        style: const TextStyle(color: Colors.black),
                      ),
                    )
                ]),
              )
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
