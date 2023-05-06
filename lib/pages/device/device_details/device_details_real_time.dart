import 'package:fire_control_app/widgets/keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:intl/intl.dart';
import 'package:fire_control_app/widgets/card_father.dart';

// 实时数据
class DetailsRealTime extends StatefulWidget {
  const DetailsRealTime({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DetailsRealTime> createState() => _DetailsRealTimeState();
}

class _DetailsRealTimeState extends State<DetailsRealTime> {
  late List<RealTimeParam> attributes = [];
  late String updateTime = '未知';

  @override
  void initState() {
    DeviceApi.useDeviceAttributes(widget.deviceId).then((value) {
      setState(() {
        attributes = value;
        if (attributes.isNotEmpty) {
          DateTime time = DateTime.fromMillisecondsSinceEpoch(
            attributes[0].upTime,
          );
          updateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
      child: ListView(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 14, bottom: 14, left: 10, right: 10),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        width: 4,
                        height: 13,
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          border: Border.all(
                              width: 1, color: const Color(0xFF1976D2)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                        )),
                    const Text(
                      '最近更新时间',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                Text(
                  updateTime,
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
          if (attributes.isNotEmpty)
            CardContainer(
              child: Column(
                children: [
                  ...attributes.map((item) {
                    return _setText(item.analogName,
                        '${item.analogValue} ${item.dataUnit}');
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
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
}
