import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final _userId = Global.profile.userId;

  final TaskItem? item;

  final bool executing;

  TaskCard({super.key, required this.item, this.executing = false});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      backgroundColor: (executing && _userId != item?.userId)
          ? const Color.fromRGBO(255, 255, 255, .5)
          : null,
      children: [
        CardHeader(
          title: item?.name ?? '-',
          tail: TaskStatusContent(
            status: item?.status ?? 0,
          ),
        ),
        XfItem(
          label: '任务编号',
          contentWidget: TaskCodeContent(
            taskCode: item?.idCode,
          ),
        ),
        XfItem(
          label: '单位名称',
          content: item?.unitName,
        ),
        Row(children: [
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检类型',
              content: item?.type.desc,
            ),
          ),
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检限时',
              content:
                  item?.limitedTime != null ? '${item?.limitedTime}分钟' : '无',
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            flex: 1,
            child: XfItem(
              label: '巡检方式',
              content: item?.planType.desc,
            ),
          ),
          Expanded(
            flex: 1,
            child: XfItem(
              label: '节点进度',
              content: '${item?.finishTotalNode}/${item?.totalNode}',
            ),
          ),
        ]),
        CardFooter(
          left: Text.rich(
              TextSpan(style: const TextStyle(fontSize: 12), children: [
            const TextSpan(
                text: '领取人：', style: TextStyle(color: FcColor.base9)),
            TextSpan(
                text: item?.userName,
                style: TextStyle(
                    color: _userId != item?.userId
                        ? const Color(0xff333333)
                        : const Color(0xffFF9800))),
          ])),
          right: _buildFooterRight(),
        ),
      ],
    );
  }

  Widget? _buildFooterRight() {
    if (item?.status == 1) {
      return Text(
        '领取时间：${item?.receiveTime}',
        style: const TextStyle(fontSize: 12, color: FcColor.base9),
      );
    }
    if (item?.status == 2) {
      return Text(
        '完成时间：${item?.finishedTime}',
        style: const TextStyle(fontSize: 12, color: FcColor.ok),
      );
    }
    if (item?.status == 3) {
      return Text(
        '过期时间：${item?.finishedTime}',
        style: const TextStyle(fontSize: 12, color: FcColor.err),
      );
    }
    return null;
  }
}

class RouteCard extends StatelessWidget {
  final RouteItem? item;

  final bool isList;

  const RouteCard({super.key, required this.item, this.isList = false});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      children: [
        CardHeader(
          title: item?.name ?? '-',
          tail: GestureDetector(
            onTap: () {
              if (item?.canReceive == 1 && isList) {
                TaskApi.receive(item!.taskId).then((value) {
                  if (value.code == 200) {
                    Message.show('领取成功');
                  }
                });
              }
            },
            child: RouteStatusContent(
              status: item?.canReceive ?? 0,
            ),
          ),
        ),
        XfItem(
          label: '单位名称',
          content: item?.unitName,
        ),
        Row(children: [
          Expanded(
            child: XfItem(
              label: '巡检类型',
              content: item?.type.desc,
            ),
          ),
          Expanded(
            child: XfItem(
              label: '巡检限时',
              content:
                  item?.limitedTime != null ? '${item?.limitedTime}分钟' : '无',
            ),
          ),
        ]),
        Row(children: [
          Expanded(
            child: XfItem(
              label: '巡检方式',
              content: item?.way.desc,
            ),
          ),
          Expanded(
            child: XfItem(
              label: '节点数量',
              content: item?.nodeCount.toString(),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: FcColor.baseF5),
              clipBehavior: Clip.hardEdge,
              height: 24,
              child: Row(children: [
                Expanded(
                    child: Container(
                        color: FcColor.baseE,
                        alignment: Alignment.center,
                        child: const Text(
                          "今日概况",
                          style: TextStyle(fontSize: 12),
                        ))),
                Expanded(
                    child: Center(
                  child: Text.rich(TextSpan(
                      style:
                          const TextStyle(fontSize: 12, color: FcColor.base9),
                      children: [
                        const TextSpan(text: '额定\u0020'),
                        TextSpan(
                            text: '${item?.amount ?? 0}',
                            style: const TextStyle(color: FcColor.base3))
                      ])),
                )),
                Expanded(
                    child: Center(
                        child: Text.rich(TextSpan(
                            style: const TextStyle(
                                fontSize: 12, color: FcColor.base9),
                            children: [
                      const TextSpan(text: '领取\u0020'),
                      TextSpan(
                          text: '${item?.receiveSum ?? 0}',
                          style: const TextStyle(color: FcColor.base3))
                    ])))),
                Expanded(
                    child: Center(
                        child: Text.rich(TextSpan(
                            style: const TextStyle(
                                fontSize: 12, color: FcColor.base9),
                            children: [
                      const TextSpan(text: '完成\u0020'),
                      TextSpan(
                          text: '${item?.finishedAmount ?? 0}',
                          style: const TextStyle(color: FcColor.ok))
                    ])))),
              ])),
        )
      ],
    );
  }
}
