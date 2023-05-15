import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';

class AlarmDetailPage extends StatefulWidget {
  static const routeName = '/alarmDetail';

  final int alarmId;

  const AlarmDetailPage({super.key, required this.alarmId});

  @override
  State<StatefulWidget> createState() => _AlarmDetailPageState();
}

class _AlarmDetailPageState extends State<AlarmDetailPage> {
  AlarmDetail? _detail;

  @override
  void initState() {
    AlarmApi.getAlarmFaultDetail(widget.alarmId).then((value) {
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
      title: '告警详情',
      body: [_buildAlarmInfo(), ..._buildConfirmInfo(), ..._buildResetInfo()],
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
        const SizedBox(
          height: 10,
        ),
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
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text.rich(TextSpan(children: [
              TextSpan(text: '报警次数 '),
              TextSpan(
                  text: '${_detail?.eventCount ?? 0}',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
            ])),
          ),
          GestureDetector(
            onTap: () {},
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
            onPressed: () {},
          ),
        )
      ];
    }
    return [];
  }
}
