import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/http/mine_api.dart';

class MineInspectionListMain extends StatefulWidget {
  const MineInspectionListMain({super.key, required this.present, this.userId});

  final MineWorkCommon present;
  final int? userId;

  @override
  State<MineInspectionListMain> createState() => _MineInspectionListMainState();
}

class _MineInspectionListMainState extends State<MineInspectionListMain> {
  late int index = 0;
  final MineInspectionCountParams _mineFireCountParams =
      MineInspectionCountParams();
  late MineInspectionCount _mineFireCount = MineInspectionCount();
  final MineInspectionParams _mineFireParam = MineInspectionParams();

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
    _mineFireCount =
        await MineInspectionApi.useUserInspectionStats(_mineFireCountParams);
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
              'index': 1,
              'name': "执行中",
              'value': _mineFireCount.ing.toString(),
              'color': const Color(0xff1976D2)
            },
            {
              'index': 2,
              'name': "已完成",
              'value': _mineFireCount.finish.toString(),
              'color': const Color(0xff4CAF50)
            },
            {
              'index': 3,
              'name': "未完成",
              'value': _mineFireCount.noFinish.toString(),
              'color': Colors.red
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
            child: MineInspectionList(
          mineFireParam: _mineFireParam,
        ))
      ],
    );
  }
}

class MineInspectionList extends StatelessWidget {
  const MineInspectionList({super.key, required this.mineFireParam});

  final MineInspectionParams mineFireParam;

  @override
  Widget build(BuildContext context) {
    return LoadList<MineInspectionApi, MineInspectionParams, MineInspectionItem>(
      api: MineInspectionApi(),
      param: mineFireParam,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, MineInspectionItem item, int index) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, '/alarmDetail', arguments: item.id);
      },
      child: CardParent(
        header: Row(children: [
          Container(
              width: 3,
              height: 16,
              color: FcColor.baseColor,
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          Expanded(
            flex: 1,
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          InkWell(
            onTap: () {
              print('可领取');
            },
            child: Container(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
              decoration: BoxDecoration(
                  color: item.status == 1
                      ? const Color(0xffE3F2FD)
                      : item.status == 2
                          ? const Color(0xffE8F5E9)
                          : const Color(0xffFFEBEE),
                  border: Border.all(
                      width: 1,
                      color: item.status == 1
                          ? const Color(0xff1976D2)
                          : item.status == 2
                              ? const Color(0xff4CAF50)
                              : const Color(0xffE53935)),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Text(
                item.status == 1
                    ? "执行中"
                    : item.status == 2
                        ? '已完成'
                        : '未完成',
                style: TextStyle(
                    fontSize: 12,
                    color: item.status == 1
                        ? const Color(0xff1976D2)
                        : item.status == 2
                            ? const Color(0xff4CAF50)
                            : const Color(0xffE53935)),
              ),
            ),
          )
        ]),
        body: Column(children: [
          XfItem(
            label: '任务编号',
            contentWidget: Text(
              item.idCode,
              softWrap: true,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: const TextStyle(fontSize: 12, color: Color(0xff3D8CD9)),
            ),
          ),
          XfItem(
            label: '单位名称',
            content: item.unitName,
          ),
          Row(children: [
            Expanded(
              flex: 1,
              child: XfItem(
                label: '巡检类型',
                content: item.type.toString(),
              ),
            ),
            Expanded(
              flex: 1,
              child: XfItem(
                label: '巡检限时',
                content:
                    item.limitedTime != null ? '${item.limitedTime}分钟' : '无',
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              flex: 1,
              child: XfItem(
                label: '巡检方式',
                content: item.planType.toString(),
              ),
            ),
            Expanded(
              flex: 1,
              child: XfItem(
                label: '节点数量',
                content: '${item.finishTotalNode}/${item.totalNode}',
              ),
            ),
          ]),
        ]),
        fotter: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '领取人：',
                  style: TextStyle(fontSize: 13, color: Color(0xff999999)),
                ),
                Text(
                  item.userName,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xffFF9800)),
                ),
              ],
            ),
            if (item.status == 1)
              Row(
                children: [
                  const Text(
                    '领取时间：',
                    style: TextStyle(fontSize: 13, color: Color(0xff999999)),
                  ),
                  Text(
                    item.receiveTime!,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                ],
              ),
            if (item.status == 2)
              Row(
                children: [
                  const Text(
                    '完成时间：',
                    style: TextStyle(fontSize: 13, color: Color(0xff4CAF50)),
                  ),
                  Text(
                    item.finishedTime!,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff4CAF50)),
                  ),
                ],
              ),
            if (item.status == 3)
              Row(
                children: [
                  const Text(
                    '过期时间：',
                    style: TextStyle(fontSize: 13, color: Color(0xffE53935)),
                  ),
                  Text(
                    item.finishedTime!,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xffE53935)),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
