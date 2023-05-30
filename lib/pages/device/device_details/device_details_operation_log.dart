import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:intl/intl.dart';

// 操作记录
class DetailsOperationLog extends StatefulWidget {
  const DetailsOperationLog({required Key key, required this.deviceId})
      : super(key: key);

  final int deviceId;

  @override
  State<DetailsOperationLog> createState() => _DetailsOperationLogState();
}

class _DetailsOperationLogState extends State<DetailsOperationLog> {
  late OperationLogParams _operationLogParam;
  @override
  void initState() {
    super.initState();
    setState(() {
      _operationLogParam = OperationLogParams(
        deviceId: widget.deviceId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadList<OperationLogApi, OperationLogParams, OperationLogItem>(
      api: OperationLogApi(),
      param: _operationLogParam,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, OperationLogItem item, int index) {
    return CardContainer(
      children: [
        CardHeader(
            title: setHappenTime(item.createTime),
            tail: setTag(statusContent(item.operationStatus),
                tagType(item.operationStatus))),
        _setText('动作', '${item.operationTypeName}'),
        _setText('人员', '${item.userNickname}'),
        _setText('备注', item.operationContent ?? ''),
      ],
    );
  }

  Widget _setText(String text, String tail) {
    return CardHeader(
      standStart: false,
      title: text,
      tail: Text(
        tail,
        style: const TextStyle(color: Color(0xFF999999), fontSize: 12),
      ),
    );
  }

  setHappenTime(happenTime) {
    if (happenTime == null) {
      return '';
    }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
      happenTime,
    );
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
  }

  List<Color> tagType(status) {
    if (status == 4 || status == 2) {
      return [const Color(0xFFE8F5E9), const Color(0xFF69BC6C)];
    } else if (status == 3 || status == 5) {
      return [const Color(0xFFFFEBEE), const Color(0xFFE53935)];
    }
    return [const Color(0xFFE3F2FD), const Color(0xFF1976D2)];
  }

  statusContent(status) {
    if (status == 1) {
      return '下发中';
    } else if (status == 2) {
      return '下发成功';
    } else if (status == 3) {
      return '下发失败';
    } else if (status == 4) {
      return '执行成功';
    } else if (status == 5) {
      return '执行失败';
    }
  }

  Widget setTag(String text, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.only(left: 1, right: 1),
      padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: colors[0],
        border: Border.all(color: colors[1], width: 0.5),
        borderRadius: BorderRadius.circular((12)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: colors[1]),
      ),
    );
  }
}
