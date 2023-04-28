import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';

class DangerDetailPage extends StatefulWidget {
  static const routeName = '/dangerDetail';

  final int dangerId;

  const DangerDetailPage({super.key, required this.dangerId});

  @override
  State<StatefulWidget> createState() => _DangerDetailPageState();
}

class _DangerDetailPageState extends State<DangerDetailPage> {
  DangerDetail? _detail;

  @override
  void initState() {
    DangerApi.getDangerDetail(widget.dangerId).then((value) {
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
      title: '危险品详情',
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
      child: Column(
        children: [
          CardHeader(
              title: '危险品信息',
              tail: InfoStatus(
                processingText: _detail?.status == 0 ? '进行中' : null,
                endedText: _detail?.status == 1 ? '已结束' : null,
              )),
          XfItem(
            label: "单位名称\u3000",
            content: _detail?.unitName,
          ),
          XfItem(
            label: "发生位置\u3000",
            content:
                '${_detail?.buildingName ?? '室外'} ${_detail?.floorNumber ?? ''} ${_detail?.roomNumber ?? ''}',
          ),
          XfItem(
            label: "上报时间\u3000",
            content: _detail?.createTime,
          ),
          XfItem(
            label: "危险品名称",
            content: _detail?.dangerName,
          ),
          XfItem(
            label: "危险品类型",
            contentWidget: Row(
              children: [
                ErrorContent(
                  message: _detail?.dangerTypeName,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    print("处置");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xffFF9800)),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '应急处置',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          XfItem(
            label: "事件描述\u3000",
            content: _detail?.cont,
          ),
          XfItem(
            label: "上传附件\u3000",
            content: 'aaaaa',
          ),
          XfItem(
            label: "上报人员\u3000",
            contentWidget: UserContent(
              name: _detail?.nickName,
              phone: _detail?.phone,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHandleInfo() {
    if (_detail?.status == 1) {
      return [
        Text(formatDuration(_detail!.createTime, _detail!.reviewTime)),
        CardContainer(
          child: Column(
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
          ),
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
            title: '处理危险品',
            onPressed: () {},
          ),
        )
      ];
    }
    return [];
  }
}
