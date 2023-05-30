import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/pages/alarm/alarm_handle.dart';
import 'package:fire_control_app/utils/alarm_tool.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';

class TroubleDetailPage extends StatefulWidget {
  static const routeName = '/troubleDetail';

  final int troubleId;

  const TroubleDetailPage({super.key, required this.troubleId});

  @override
  State<StatefulWidget> createState() => _TroubleDetailPageState();
}

class _TroubleDetailPageState extends State<TroubleDetailPage> {
  TroubleDetail? _detail;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    TroubleApi.getTroubleDetail(widget.troubleId).then((value) {
      if (mounted) {
        setState(() {
          _detail = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '隐患详情',
      body: [_buildAlarmInfo(), ..._buildHandleInfo()],
      footer: [
        Expanded(
          flex: 2,
          child: LocationButton(
            onPressed: () {},
          ),
        ),
        ..._buildHandleButton()
      ],
    );
  }

  Widget _buildAlarmInfo() {
    return CardContainer(
      children: [
        CardHeader(
            title: '隐患信息',
            tail: InfoStatus(
              processingText: _detail?.status == 0 ? '进行中' : null,
              endedText: _detail?.status == 1 ? '已结束' : null,
            )),
        XfItem(
          label: "单位名称",
          content: _detail?.unitName,
        ),
        XfItem(
          label: "发生位置",
          content:
              '${_detail?.buildingName ?? '室外'} ${_detail?.floorNumber ?? ''} ${_detail?.roomNumber ?? ''}',
        ),
        XfItem(
          label: "上报时间",
          content: _detail?.createTime,
        ),
        XfItem(
          label: "隐患类型",
          contentWidget: ErrorContent(
            message: getTroubleTypeDesc(_detail?.type),
          ),
        ),
        XfItem(
          label: "紧急程度",
          contentWidget: Row(
            children: [
              TroubleLevelContent(
                level: _detail?.levels ?? 1,
              )
            ],
          ),
        ),
        XfItem(
          label: "事件描述",
          content: _detail?.cont,
        ),
        XfItem(
          label: "上传附件",
          content: 'aaaaaaaaa',
        ),
        XfItem(
          label: "上报人员",
          contentWidget: UserContent(
            name: _detail?.nickName,
            phone: _detail?.phone,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildHandleInfo() {
    if (_detail?.status == 1) {
      return [
        Text(formatDuration(_detail!.createTime, _detail!.reviewTime)),
        CardContainer(
          children: [
            CardHeader(
              title: "处理信息",
              tail: Text(_detail?.reviewTime ?? ''),
            ),
            XfItem(
                label: "处理人员",
                contentWidget: UserContent(
                  name: _detail?.reviewerName,
                  phone: _detail?.reviewerPhone,
                )),
            XfItem(
              label: "处理描述",
              content: _detail?.treatment,
            ),
            XfItem(
              label: "上传附件",
              content: "aaaaaa",
            ),
          ],
        )
      ];
    }
    return [];
  }

  List<Widget> _buildHandleButton() {
    if (_detail?.status == 0) {
      return [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: HandleButton(
            title: '处理隐患',
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  HandlePage.routeName,
                  arguments: HandlePageParam(
                      id: widget.troubleId,
                      type: HandlePageType.trouble
                  )
              ).then((value) {
                if (value != null && value as bool) {
                  _fetchData();
                }
              });
            },
          ),
        )
      ];
    }
    return [];
  }
}
