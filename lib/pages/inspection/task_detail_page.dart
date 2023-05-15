import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/fc_icon.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/pages/inspection/inspection_card.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  static const routeName = '/taskDetail';

  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<StatefulWidget> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  TaskDetail? _detail;

  @override
  void initState() {
    TaskApi.getTaskDetail(widget.taskId).then((value) {
      if (mounted) {
        setState(() {
          _detail = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '任务详情',
      roll: false,
      body: [
        TaskCard(item: _detail),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '节点列表',
                style: TextStyle(fontSize: 16),
              ),
              if (_detail?.status == 1)
                ElevatedButton.icon(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(FcColor.warn),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        iconSize: MaterialStateProperty.all(18),
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 15))),
                    icon: const Icon(MsgIcon.trouble),
                    label: const Text('上报隐患')),
              if (_detail?.status == 2 || _detail?.status == 3)
                Text(
                  '领取时间：${_detail?.receiveTime}',
                  style: const TextStyle(fontSize: 12, color: FcColor.base9),
                )
            ],
          ),
        ),
        Expanded(
          child: _buildNodeList(_detail?.nodes ?? [], _detail?.status ?? 0),
        )
      ],
    );
  }

  Widget _buildNodeList(List<InspectionNode> nodes, int status) {
    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (c, i) {
          InspectionNode node = nodes[i];
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            // padding: EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xffECEFF1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  width: 28,
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Center(
                    child: Text(
                      i.toString(),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff607D8B)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(node.location),
                            if (node.status == 2 || node.remark.isNotEmpty)
                              Text(
                                node.punchTime!,
                                style: const TextStyle(
                                    fontSize: 12, color: FcColor.base9),
                              )
                          ],
                        ),
                        if (node.status == 1 && status == 1)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Color(0xffE3F2FD),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.note_alt_outlined,
                                    color: Color(0xff1976D2),
                                    size: 19,
                                  ),
                                  Text('\u0020打卡'),
                                ],
                              ),
                            ),
                          ),
                        if (node.status == 1 && status == 3)
                          const Text(
                            '已过期',
                            style: TextStyle(color: FcColor.err),
                          ),
                        if (node.remark.isNotEmpty)
                          Column(
                            children: [
                              const Text(
                                '异常打卡',
                                style: TextStyle(color: FcColor.warn),
                              ),
                              Text(
                                node.remark,
                                style: const TextStyle(
                                    fontSize: 12, color: FcColor.base6),
                              )
                            ],
                          ),
                        if (node.status != 1 &&
                            status == 2 &&
                            node.remark.isEmpty)
                          const Text(
                            '已完成',
                            style: TextStyle(color: FcColor.ok),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: nodes.length,
      ),
    );
  }
}
