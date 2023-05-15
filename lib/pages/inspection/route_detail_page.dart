import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/pages/inspection/inspection_card.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';

class RouteDetailPage extends StatefulWidget {
  static const routeName = '/routeDetail';

  final int routeId;

  const RouteDetailPage({super.key, required this.routeId});

  @override
  State<StatefulWidget> createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  RouteDetail? _detail;

  @override
  void initState() {
    RouteApi.getRouteDetail(widget.routeId).then((value) {
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
      title: '路线详情',
      roll: false,
      body: [
        RouteCard(item: _detail),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: const Text(
            '节点列表',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(child: _buildNodeList(_detail?.nodes ?? []))
      ],
      footer: [
        if (_detail?.canReceive == 1)
          Expanded(
            child: HandleButton(
              onPressed: () {
                TaskApi.receive(widget.routeId).then((value) {
                  if (value.code == 200) {
                    Message.show('领取成功');
                    _detail!.canReceive = 2;
                    setState(() {});
                  }
                });
              },
              title: '领取任务',
            ),
          )
      ],
    );
  }

  Widget _buildNodeList(List<InspectionNode> nodes) {
    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (c, i) {
          InspectionNode node = nodes[i];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                      (i + 1).toString(),
                      style: const TextStyle(fontSize: 12, color: Color(0xff607D8B)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.all(10), child: Text(node.location)),
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
