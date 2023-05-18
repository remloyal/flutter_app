
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcPage extends StatefulWidget {

  static const routeName = '/nfcPunch';

  final PunchParam param;

  const NfcPage({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo.then((value) {
        String mainVersion = value.systemVersion.split('.')[0];
        double version = double.parse(mainVersion);
        if (!value.isPhysicalDevice || version < 13.0) {
          _showNotSupport();
        } else {
          _initNfc();
        }
      });
    } else if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((value) {
        if (!value.isPhysicalDevice || value.version.sdkInt < 19.0) {
          _showNotSupport();
        } else {
          _initNfc();
        }
      });
    }
    super.initState();
  }

  void _showNotSupport() {
    Message.show('该设备不支持NFC功能!');
  }

  Future<void> _initNfc() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      Message.show('请在系统设置中先启用NFC功能!');
      return;
    }
    _tagRead();
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      debugPrint('nfc data: ${tag.data}');
      var records = tag.data['ndef']?['cachedMessage']?['records'];
      if (records != null && records.isNotEmpty) {
        var source = records[0]['payload'];
        if (source == null) return;
        String payload = String.fromCharCodes(source);
        debugPrint('nfc payload: $payload');
        String content = payload.substring(payload.indexOf('en') + 2);
        widget.param.code = content;
        TaskApi.punch(widget.param).then((value) {
          if (value.code == 200) {
            // 打卡成功
            NfcManager.instance.stopSession();
            PunchResult result = PunchResult.fromJson(value.data);
            Navigator.pop(context, result);
          }
        });
      }
    }, onError: (NfcError error) async {
      if (mounted) {
        NfcManager.instance.stopSession();
        _tagRead();
      }
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('NFC打卡'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Image.asset('assets/images/nfc.png', width: width, height: width,),
            ),
            const Text('请将NFC标签或者贴纸靠近手机背面', style: TextStyle(fontSize: 18, color: Color(0xff4acf50)),)
          ],
        ),
      ),
    );
  }
}