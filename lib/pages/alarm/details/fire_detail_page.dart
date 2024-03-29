import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/pages/alarm/alarm_handle.dart';
import 'package:fire_control_app/pages/map/map.dart';
import 'package:fire_control_app/pages/map/map_method.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';

class FireDetailPage extends StatefulWidget {
  static const routeName = "/fireDetail";

  final int fireId;

  const FireDetailPage({super.key, required this.fireId});

  @override
  State<StatefulWidget> createState() => _FireDetailPageState();
}

class _FireDetailPageState extends State<FireDetailPage> {
  FireDetail? _detail;

  MapInfo mapInfo = MapInfo();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    FireApi.getFireDetail(widget.fireId).then((value) {
      if (mounted) {
        setState(() {
          _detail = value;
          initMapPoint();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '火情详情',
      body: [_buildFireInfo(), ..._buildConfirmInfo(), ..._buildClosedInfo()],
      footer: [
        Expanded(
          flex: 2,
          child: LocationButton(
            onPressed: () {
              Navigator.pushNamed(context, MapCase.routeName, arguments: {
                'info': mapInfo,
              });
            },
          ),
        ),
        ..._buildHandleButton()
      ],
    );
  }

  Widget _buildFireInfo() {
    return CardContainer(
      children: [
        CardHeader(
          title: "火情信息",
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
          content: '${_detail?.buildingName ?? '室外'} ${_detail?.floorNumber ?? ''} ${_detail?.roomNumber ?? ''}',
        ),
        XfItem(
          label: "告警时间",
          content: _detail?.startTime,
        ),
        ..._buildFireTypeItems(),
        if (_detail?.videos != null && _detail!.videos!.isNotEmpty)
          AssociateVideos(
            videos: _detail!.videos!,
          )
      ],
    );
  }

  List<Widget> _buildFireTypeItems() {
    if (_detail?.fireType == 1) {
      return [
        XfItem(
          label: "火情描述",
          content: _detail?.remark,
        ),
        XfItem(
          label: "上传附件",
          content: _detail?.remark,
        ),
        XfItem(
            label: "上报人员",
            contentWidget: UserContent(
              name: _detail?.nickName,
              phone: _detail?.phone,
            )),
      ];
    } else if (_detail?.fireType == 2 || _detail?.fireType == 3) {
      return [
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
          contentWidget: ErrorContent(
            message: _detail?.eventTypeContent,
          ),
        ),
      ];
    }
    return [];
  }

  List<Widget> _buildConfirmInfo() {
    if (_detail?.fireType == 2 && _detail!.confirmNickName.isNotEmpty) {
      return [
        Text(formatDuration(_detail!.startTime, _detail!.confirmTime)),
        CardContainer(
          children: [
            CardHeader(
              title: "确认信息",
              tail: Text(_detail?.confirmTime ?? ''),
            ),
            const XfItem(
                label: "确认火情",
                contentWidget: Text(
                  '是',
                  style: TextStyle(color: Colors.red),
                )),
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

  List<Widget> _buildClosedInfo() {
    if (_detail?.status == 1 && _detail!.cancelNickName.isNotEmpty) {
      return [
        Text(formatDuration(_detail!.startTime, _detail!.endTime)),
        CardContainer(
          children: [
            CardHeader(
              title: "关闭信息",
              tail: Text(_detail?.endTime ?? ''),
            ),
            XfItem(
                label: "关闭人员",
                contentWidget: UserContent(
                  name: _detail?.cancelNickName,
                  phone: _detail?.cancelPhone,
                )),
            XfItem(
              label: "关闭描述",
              content: _detail?.cancelRemark,
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
            title: '关闭火情',
            onPressed: () {
              Navigator.pushNamed(context, HandlePage.routeName,
                      arguments: HandlePageParam(id: widget.fireId, type: HandlePageType.fire))
                  .then((value) {
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

  initMapPoint() async {
    if (_detail!.svgUrl != null) {
      mapInfo.type = MapType.mapPlan;
      mapInfo.setPlan(
        _detail!.svgUrl!,
        [_detail!.xRate, _detail!.yRate],
        'fire',
      );
    } else {
      mapInfo.type = MapType.map;
    }
    mapInfo.typeIndex = 4;

    mapInfo.setUnnit(_detail!.unitId);
    if (_detail!.lbsList != null) {
      mapInfo.setDevice(_detail!.lbsList!);
    }
    mapInfo.point = [_detail!.pointX, _detail!.pointY];
    mapInfo.setMainPoint([_detail!.pointY, _detail!.pointX], 'fire');
  }
}
