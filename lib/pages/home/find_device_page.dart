
import 'dart:core';

import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/pages/device/device.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/widgets/scan.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FindDevicePage extends StatelessWidget {
  static const routeName = '/findDevice';

  static const List<String> _patterns = [
    'IMEI=("|\')?([a-z0-9A-Z]+)("|\')?',
    'ICCID=("|\')?([a-z0-9A-Z]+)("|\')?',
    'materNo=("|\')?([a-z0-9A-Z]+)("|\')?',
    'CCID=("|\')?([a-z0-9A-Z]+)("|\')?',
    'ID=("|\')?([a-z0-9A-Z]+)("|\')?',
    '=("|\')?([a-z0-9A-Z]+)("|\')?',
    '("|\')?(^[a-z0-9A-Z]+)("|\')?',
  ];

  const FindDevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScanController controller = ScanController();
    bool isProcessing = false;
    return Scan(
      controller: controller,
      onDetect: (capture) {
        if (isProcessing) return;
        isProcessing = true;

        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          Barcode barcode = barcodes[0];
          debugPrint('Barcode found! ${barcode.rawValue}');
          if (barcode.rawValue == null) return;
          String? result;
          for (var element in _patterns) {
            RegExp regExp = RegExp(element);
            RegExpMatch? match = regExp.firstMatch(barcode.rawValue!);
            result = match?.group(2);
            if (result != null) break;
          }

          isProcessing = false;
          if (result != null) {
            controller.stop();
            FindParam param = FindParam(source: barcode.rawValue!, keyword: result);
            Navigator.pushNamed(context, FindResultPage.routeName, arguments: param).then((value) {
              controller.start();
            }, onError: (e) {
              controller.start();
            });
          }
        }
      },
    );
  }
}

class FindResultPage extends StatefulWidget {

  static const routeName = '/findResult';

  final FindParam param;

  const FindResultPage({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _FindResultPageState();
}

class _FindResultPageState extends State<FindResultPage> {
  @override
  Widget build(BuildContext context) {
    DeviceParams params = DeviceParams();
    params.keyword = widget.param.keyword;
    return FcDetailPage(
      title: '查找设备',
      roll: false,
      body: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 18, color: Colors.black),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('识别结果: '),
                Expanded(
                  child: Text(widget.param.source),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Device(showFilter: false, params: params),
        ),
      ],
      footer: [
        Expanded(
          child: HandleButton(
            onPressed: () {
              Navigator.pop(context);
            },
            title: '重新扫描',
          ),
        )
      ],
    );
  }
}