import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmAnalog extends StatelessWidget with ListBuilder<AnalogItem> {

  final int alarmId;

  final AnalogParam _param;

  AlarmAnalog({super.key, required this.alarmId})
      : _param = AnalogParam(alarmId: alarmId)..pageSize = 30;

  @override
  Widget build(BuildContext context) {
    return LoadList<AnalogApi, AnalogParam>(
        api: AnalogApi(), param: _param, listBuilder: this);
  }

  @override
  Widget? buildToolbar(BuildContext context, int total) {
    return const DefaultTextStyle(
      style: TextStyle(color: FcColor.base9),
      child: Row(
        children: [
          Expanded(child: Text('序号')),
          Expanded(flex: 3, child: Text('时间')),
        ],
      ),
    );
  }

  @override
  Widget buildItem(BuildContext context, AnalogItem item) {
    String prefix = '+';
    if (item.type == 3) prefix = '-';
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      item.time,
    );
    String time =  DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return Column(
      children: [
        const Divider(),
        DefaultTextStyle(
          style: const TextStyle(color: FcColor.base6),
          child: Row(
            children: [
              const Expanded(child: Text('序号')),
              Expanded(flex: 3, child: Text('$prefix $time')),
            ],
          ),
        )
      ],
    );
  }
}