import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/pages/alarm/alarm_handle.dart';
import 'package:fire_control_app/pages/alarm/details/alarm_analog.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/widgets/fc_drawer.dart';
import 'package:flutter/material.dart';

enum AlarmDetailType {
  //告警
  alarm,
  //故障
  fault
}

class AlarmDetailParam {
  int alarmId;
  AlarmDetailType type;

  AlarmDetailParam({required this.alarmId, required this.type});
}

class AlarmFaultDetailPage extends StatefulWidget {
  static const routeName = '/alarmFaultDetail';

  final AlarmDetailParam param;

  const AlarmFaultDetailPage({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _AlarmFaultDetailPageState();
}

class _AlarmFaultDetailPageState extends State<AlarmFaultDetailPage> {
  AlarmDetail? _detail;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    AlarmApi.getAlarmFaultDetail(widget.param.alarmId).then((value) {
      if (mounted) {
        setState(() {
          _detail = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '告警详情';
    int flex = 2;
    if (widget.param.type == AlarmDetailType.fault) {
      title = '故障详情';
      flex = 1;
    }

    List<Widget> footer = [
      Expanded(
          flex: flex,
          child: LocationButton(
            onPressed: () {},
          )
      ),
      if (widget.param.type == AlarmDetailType.alarm)
        ..._buildHandleButton()
    ];

    return FcDetailPage(
      title: title,
      body: [_buildAlarmInfo(), ..._buildConfirmInfo(), ..._buildResetInfo()],
      footer: footer,
    );
  }

  Widget _buildAlarmInfo() {
    return CardContainer(
      children: [
        CardHeader(
          title: '告警信息',
          tail: InfoStatus(
            processingText: _detail?.status == 0 ? '进行中' : null,
            endedText: _detail?.status == 1 ? '已结束' : null,
          ),
        ),
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
          label: "告警时间",
          content: _detail?.startTime,
        ),
        XfItem(
          label: "告警设备",
          content: _detail?.deviceName,
        ),
        XfItem(
          label: "设备类型",
          content: _detail?.deviceTypeName,
        ),
        XfItem(
          label: "设备MAC",
          content: _detail?.deviceMac,
        ),
        XfItem(
          label: "告警事件",
          contentWidget: ErrorContent(message: _detail?.eventTypeContent),
        ),
        if (_detail?.eventCount != null && _detail!.eventCount! > 0)
          _buildAlarmCount(_detail!.eventCount!),
        if (_detail?.videos != null && _detail!.videos!.isNotEmpty)
          AssociateVideos(videos: _detail!.videos!)
      ],
    );
  }

  Widget _buildAlarmCount(int count) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: FcColor.barMineColor,
      ),
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: '报警次数 '),
              TextSpan(
                  text: '${_detail?.eventCount ?? 0}',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
            ])),
          ),
          GestureDetector(
            onTap: () {
              showRightDrawer(
                  context: context,
                  builder: (ctx) => AlarmAnalog(alarmId: widget.param.alarmId)
              );
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(25)),
                  color: Colors.red),
              child: Text(
                '查看日志',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildConfirmInfo() {
    if (_detail?.confirmTime != null) {
      return [
        Text(formatDuration(_detail!.startTime, _detail!.confirmTime)),
        CardContainer(
          children: [
            CardHeader(
              title: "确认信息",
              tail: Text(_detail?.confirmTime ?? ''),
            ),
            XfItem(
                label: "是否火情",
                contentWidget: ErrorContent(
                    message: _detail?.confirmResult == 1 ? '是' : '误报')),
            XfItem(
                label: "确认人员",
                contentWidget: UserContent(
                  name: _detail?.confirmNickName,
                  phone: _detail?.confirmPhone,
                )),
            XfItem(
              label: "确认描述",
              content: _detail?.confirmReason,
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

  List<Widget> _buildResetInfo() {
    if (_detail?.resetTime != null) {
      return [
        Text(formatDuration(_detail!.startTime, _detail!.resetTime)),
        CardContainer(
          backgroundColor: Color(0xffA5D6A7),
          children: [
            CardHeader(
              title: '复位时间',
              leadingColor: Color(0xff4CAF50),
              divider: false,
              tail: Text(
                _detail!.resetTime!,
                style: TextStyle(color: Color(0xff4CAF50)),
              ),
            ),
          ],
        )
      ];
    }
    return [];
  }

  List<Widget> _buildHandleButton() {
    if (_detail?.status == 0 && _detail?.confirmResult == 0) {
      return [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: HandleButton(
            title: '关闭告警',
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  HandlePage.routeName,
                  arguments: HandlePageParam(
                      id: widget.param.alarmId,
                      type: HandlePageType.alarm
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
