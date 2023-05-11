import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/http/mine_api.dart';

class MineAlarmListMain extends StatefulWidget {
  const MineAlarmListMain({super.key, required this.present, this.userId});

  final MineWorkCommon present;
  final int? userId;

  @override
  State<MineAlarmListMain> createState() => _MineAlarmListMainState();
}

class _MineAlarmListMainState extends State<MineAlarmListMain> {
  late int index = 0;
  final MineAlarmCountParams _mineFireCountParams = MineAlarmCountParams();
  late MineAlarmCount _mineFireCount = MineAlarmCount();
  final MineAlarmParams _mineFireParam = MineAlarmParams();

  @override
  void initState() {
    super.initState();
    _mineFireParam.beginTime = widget.present.beginTime;
    _mineFireParam.endTime = widget.present.endTime;
    _mineFireCountParams.beginTime = widget.present.beginTime;
    _mineFireCountParams.endTime = widget.present.endTime;
    if (widget.userId != null) {
      _mineFireParam.userId = widget.userId;
      _mineFireCountParams.userId = widget.userId;
    }
    _init();
    // 监听父级改变
    widget.present.addListener(() {
      _mineFireParam.currentPage = 1;
      _mineFireParam.beginTime = widget.present.beginTime;
      _mineFireParam.endTime = widget.present.endTime;
      _mineFireCountParams.beginTime = widget.present.beginTime;
      _mineFireCountParams.endTime = widget.present.endTime;
      _mineFireParam.change();
      _init();
    });
  }

  _init() async {
    _mineFireCount = await MineAlarmApi.useUserFireStats(_mineFireCountParams);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonTotal(
          index: index,
          total: _mineFireCount.total,
          list: [
            {
              'index': 0,
              'name': "报警中",
              'value': _mineFireCount.ing.toString(),
              'color': const Color(0xffE53935)
            },
            {
              'index': 1,
              'name': "已关闭",
              'value': _mineFireCount.end.toString(),
              'color': const Color(0xff4CAF50)
            }
          ],
          onChang: (data) {
            index = data['index'];
            _mineFireParam.status = index;
            _mineFireParam.change();
            setState(() {});
          },
        ),
        Expanded(
            child: MineAlarmList(
          mineFireParam: _mineFireParam,
        ))
      ],
    );
  }
}

class MineAlarmList extends StatefulWidget {
  const MineAlarmList({super.key, required this.mineFireParam});

  final MineAlarmParams mineFireParam;

  @override
  State<MineAlarmList> createState() => _MineAlarmListState();
}

class _MineAlarmListState extends State<MineAlarmList>
    with ListBuilder<MineAlarmItem> {
  @override
  Widget build(BuildContext context) {
    return LoadList<MineAlarmApi, MineAlarmParams>(
        api: MineAlarmApi(), param: widget.mineFireParam, listBuilder: this);
  }

  @override
  Widget buildItem(BuildContext context, MineAlarmItem item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/alarmDetail', arguments: item.id);
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
                      ? formatDurationByStart(item.startTime!) ?? '-'
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
              content: item.deviceName,
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
                  item.startTime!,
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
                    item.confirmTime!,
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
