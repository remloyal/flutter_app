import 'package:fire_control_app/common/colors.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<StatefulWidget> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  final RouteParam _routeParam = RouteParam();

  @override
  Widget build(BuildContext context) {
    return LoadList(
        api: InspectionApi.getInspectionList,
        param: _routeParam,
        precedent: RouteResponse(),
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
                names: const ['可领取', '已领取'],
                height: 30,
                onTap: (index) {
                  print(index);
                  if (index == 1) {
                    _routeParam.status = 2;
                  } else {
                    _routeParam.status = 1;
                  }
                  _routeParam.change();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
              ),
            )
          ],
        ));
  }

  _setTtem(item) {
    return _RouteItem(route: item);
  }
}

class _RouteItem extends StatelessWidget {
  final InspectionRoute route;

  const _RouteItem({required this.route});

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
            route.name,
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
                color: route.canReceive == 1
                    ? const Color(0xffFFF3E0)
                    : const Color(0xffF5F5F5),
                border: Border.all(
                    width: 1,
                    color: route.canReceive == 1
                        ? const Color(0xffFF9800)
                        : const Color(0xffAAAAAA)),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Text(
              route.canReceive == 1 ? "可领取" : '已领取',
              style: TextStyle(
                  fontSize: 12,
                  color: route.canReceive == 1
                      ? const Color(0xffFF9800)
                      : const Color(0xffAAAAAA)),
            ),
          ),
        )
      ]),
      body: Column(children: [
        XfItem(
          label: '单位名称',
          content: route.unitName,
        ),
        Row(children: [
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检类型',
              content: route.type.desc,
            ),
          ),
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检限时',
              content:
                  route.limitedTime != null ? '${route.limitedTime}分钟' : '无',
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检方式',
              content: route.way.desc,
            ),
          ),
          Expanded(
            flex: 1,
            child: XfItem(
              label: '节点数量',
              content: route.nodeCount.toString(),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(66, 211, 211, 211)),
              clipBehavior: Clip.hardEdge,
              height: 24,
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        color: const Color(0xffeeeeee),
                        child: const Center(
                            child: Text(
                          "今日概况",
                          style: TextStyle(fontSize: 12),
                        )))),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Row(
                      children: [
                        const Text(
                          "额定",
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            "${route.amount}",
                            style: const TextStyle(fontSize: 12, height: 1.5),
                          ),
                        ),
                      ],
                    ))),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Row(
                      children: [
                        const Text(
                          "领取",
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            "${route.receiveSum}",
                            style: const TextStyle(fontSize: 12, height: 1.5),
                          ),
                        ),
                      ],
                    ))),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Row(
                      children: [
                        const Text(
                          "完成",
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            "${route.finishedAmount}",
                            style: const TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Color(0xff4CAF50)),
                          ),
                        ),
                      ],
                    ))),
              ])),
        ),
      ]),
    );
  }
}
