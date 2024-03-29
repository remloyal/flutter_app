import 'package:fire_control_app/pages/alarm/alarm_filter.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/utils/fire_date.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/utils/alarm_tool.dart';

class RiskList extends StatelessWidget {

  final RiskParam _alarmParam;

  RiskList({super.key}) : _alarmParam = RiskParam();


  @override
  Widget build(BuildContext context) {
    return LoadList<RiskApi, RiskParam, RiskItem>(
      api: RiskApi(),
      param: _alarmParam,
      toolbarBuilder: _buildToolbar,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildToolbar(BuildContext context, int total) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ButtonGroup(
                names: const ['告警中', '已解除'],
                height: 30,
                onTap: (index) {
                  _alarmParam.warnStatus = index + 1;
                  _alarmParam.change();
                },
              ),
            ),
            Text(
              '共 $total 条',
              style: const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
            ),
            RiskFilter(
              param: _alarmParam,
            )
          ],
        ));
  }

  Widget _buildItem(BuildContext context, RiskItem item, int index) {
    return InkWell(
      onTap: () {

      },
      child: CardParent(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    const IconData(0xe627, fontFamily: 'fcm'),
                    color: item.warnStatus == 1
                        ? const Color(0xff1976D2)
                        : const Color(0xffcccccc),
                    size: 16,
                  ),
                ),
                Text(
                  item.warnStatus == 1 ? '风险告警' : '风险解除',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  const IconData(0xe806, fontFamily: 'fcm'),
                  color: item.warnStatus == 1
                      ? const Color(0xff1976D2)
                      : const Color(0xff4CAF50),
                  size: 16,
                ),
                Text(
                  item.warnStatus == 1
                      ? formatDurationByStart(item.startTime) ?? '-'
                      : formatDuration(item.startTime, item.endTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: item.warnStatus == 1
                        ? const Color(0xff1976D2)
                        : const Color(0xff4CAF50),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            XfItem(
              label: '单位名称',
              content: item.unitName,
            ),
            XfItem(
              label: '告警来源',
              content: item.warnSource,
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: XfItem(
                    label: '风险类型',
                    contentWidget: Text(
                      '${getRiskTypeDesc(item.warnType)}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xffE53935)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: XfItem(
                    label: '标准分值',
                    contentWidget: Text(
                      '${item.standardValue}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff1976D2)),
                    ),
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: XfItem(
                    label: '告警分值',
                    contentWidget: Text(
                      '${item.warnValue}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xffE53935)),
                    ),
                  ),
                ),
                if (item.warnStatus == 2)
                  Expanded(
                    flex: 1,
                    child: XfItem(
                      label: '解除分值',
                      contentWidget: Text(
                        '${item.relieveWarnValue}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xff4CAF50)),
                      ),
                    ),
                  ),
              ],
            ),
            XfItem(
              label: '告警说明',
              content: item.warnContent,
            ),
          ],
        ),
        fotter: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  IconData(0xe997, fontFamily: 'fcm'),
                  color: Color(0xff999999),
                  size: 16,
                ),
                Text(
                  item.startTime,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xff999999)),
                ),
              ],
            ),
            if (item.warnStatus == 2)
              Row(
                children: [
                  const Icon(
                    IconData(0xe6ca, fontFamily: 'fcm'),
                    color: Color(0xff999999),
                    size: 16,
                  ),
                  Text(
                    item.endTime,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
