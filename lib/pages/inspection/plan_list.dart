import 'package:flutter/material.dart';
import 'package:fire_control_app/common/colors.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/common/global.dart';

class PlanList extends StatefulWidget {
  const PlanList({super.key});

  @override
  State<StatefulWidget> createState() => _PlanListState();
}

final _userId = Global.profile.userId;

class _PlanListState extends State<PlanList> {
  final PlanParam _routeParam = PlanParam();
  @override
  Widget build(BuildContext context) {
    return LoadList(
        api: InspectionApi.getReceiveTaskList,
        param: _routeParam,
        precedent: PlanCase(),
        setTtem: _setTtem,
        header: _header);
  }

  _header(data) {
    return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: ButtonGroup(
                names: const ['执行中', '已完成', '未完成'],
                height: 30,
                onTap: (index) {
                  print(index);
                  _routeParam.status = index + 1;
                  _routeParam.change();
                },
              ),
            ),
            Row(
              children: [
                Text(
                  '共 ${data.totalRow ?? 0} 条',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => const FilterDialog(
                              body: Text(
                                  "dkjfalkdjfkaldsjfkdlsajjjjjjjjjfklsdfjllaskfj\njjjjjjjjjjjjjjj"),
                            ));
                  },
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
            )
          ],
        ));
  }

  _setTtem(item) {
    return _PlanItem(item: item);
  }
}

class _PlanItem extends StatelessWidget {
  final PlanResult item;
  const _PlanItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return CardParent(
      header: Row(children: [
        Container(
            width: 3,
            height: 16,
            color: FireControlColor.baseColor,
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
          content: item.idCode,
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
              content: item.type.desc,
            ),
          ),
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检限时',
              content: item.limitedTime != null ? '${item.limitedTime}分钟' : '无',
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检方式',
              content: item.planType.desc,
            ),
          ),
          Expanded(
            flex: 1,
            child: XfItem(
              label: '节点进度',
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
                '${item.userName}',
                style: TextStyle(
                    fontSize: 12,
                    color: _userId != item.userId
                        ? const Color(0xff333333)
                        : const Color(0xffFF9800)),
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
                  item.finishedTime,
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
                  item.finishedTime,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xffE53935)),
                ),
              ],
            )
        ],
      ),
    );
  }
}
