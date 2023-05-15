import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/utils/value.dart';

class DetailsInfo extends StatelessWidget {
  const DetailsInfo({super.key, required this.device});
  final DeviceDetails device;

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

  @override
  Widget build(BuildContext context) {
    // 基础信息
    final List basicData = [
      {'left': '单位名称', 'right': device.unitName},
      {
        'left': '设备位置',
        'right':
            formatStrWithDefault(device.buildingName, defaultValueOutdoor) +
                ' ' +
                formatStr(device.floorNumber) +
                ' ' +
                formatStr(device.roomNumber),
      },
      {'left': '设备类型', 'right': device.deviceTypeName},
      {'left': '设备MAC', 'right': device.mac},
      {'left': 'ICCID', 'right': device.iccId ?? ''},
      {'left': 'IMEI', 'right': device.imei ?? ''},
      {'left': '备注', 'right': device.remark ?? ''},
    ];

    // 摄像头信息
    final List cameraData = [
      {'left': '厂商', 'right': device.manufactorId ?? ''},
      {'left': '序列号', 'right': device.deviceSerial ?? ''},
      {'left': '通道号', 'right': device.channelNo ?? ''},
      {'left': 'SD卡', 'right': device.sd == 1 ? '有' : '无'},
    ];

    // 维保信息
    final List maintenanceData = [
      {'left': '维保单位', 'right': device.maintenanceUnit},
      {'left': '维保人员', 'right': device.maintenanceUser},
      {'left': '维保电话', 'right': device.maintenancePhone},
      {'left': '投入时间', 'right': device.startDate ?? ''},
      {'left': '更换周期', 'right': '${device.lifeMonth ?? 0}天'},
      {'left': '运行时长', 'right': '${device.runDay ?? 0}天'},
    ];
    return KeepAliveWrapper(
      child: ListView(children: [
        CardContainer(
            children: [
              const CardHeader(
                title: "基础信息",
              ),
              ...basicData.map((item) {
                return _setText(
                    item['left'].toString(), item['right'].toString());
              }).toList(),
            ],
        ),
        if (device.deviceTypeId == 7 ||
            device.deviceTypeId == 242 ||
            device.deviceTypeId == 243)
          CardContainer(
              children: [
                const CardHeader(
                  title: "摄像头信息",
                ),
                ...cameraData.map((item) {
                  return _setText(
                      item['left'].toString(), item['right'].toString());
                }).toList(),
              ],
          ),
        CardContainer(
            children: [
              const CardHeader(
                title: "维保信息",
              ),
              ...maintenanceData.map((item) {
                return _setText(
                    item['left'].toString(), item['right'].toString());
              }).toList(),
            ],
        )
      ]),
    );
  }
}
