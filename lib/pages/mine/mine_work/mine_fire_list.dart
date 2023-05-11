import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/pages/alarm/details/fire_detail_page.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/http/mine_api.dart';

class MineFireListMain extends StatefulWidget {
  const MineFireListMain({super.key, required this.present, this.userId});

  final MineWorkCommon present;
  final int? userId;

  @override
  State<MineFireListMain> createState() => _MineFireListMainState();
}

class _MineFireListMainState extends State<MineFireListMain> {
  late int index = 0;
  final MineFireCountParams _mineFireCountParams = MineFireCountParams();
  late MineFireCount _mineFireCount = MineFireCount();
  final MineFireParams _mineFireParam = MineFireParams();

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
    _mineFireCount = await MineFireApi.useUserFireStats(_mineFireCountParams);
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
            child: MineFireList(
          mineFireParam: _mineFireParam,
        ))
      ],
    );
  }
}

class MineFireList extends StatefulWidget {
  const MineFireList({super.key, required this.mineFireParam});

  final MineFireParams mineFireParam;

  @override
  State<MineFireList> createState() => _MineFireListState();
}

class _MineFireListState extends State<MineFireList>
    with ListBuilder<MineFireItem> {
  @override
  Widget build(BuildContext context) {
    return LoadList<MineFireApi, MineFireParams>(
        api: MineFireApi(), param: widget.mineFireParam, listBuilder: this);
  }

  @override
  Widget buildItem(BuildContext context, MineFireItem item) {
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
                    color: item.status == 1
                        ? const Color(0xffcccccc)
                        : const Color(0xffE53935),
                    size: 16,
                  ),
                ),
                Text(item.status == 1
                    ? '火情关闭'
                    : item.fireType == 1
                        ? '人员上报火情'
                        : "确认设备报警")
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
                      : formatDuration(item.startTime, item.endTime),
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
                content: item.deviceName,
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
                  content: item.fireType == 3 ? '智能监控设备' : item.nickName,
                  contentWidget: UserContent(
                    name: item.nickName,
                    phone: item.phone,
                  )),
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
                    IconData(0xe6c5, fontFamily: 'fcm'),
                    color: Color(0xff999999),
                    size: 16,
                  ),
                  Text(
                    item.endTime!,
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
