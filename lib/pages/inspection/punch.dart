import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/widgets/scan.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// nfc打卡
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
    super.initState();
    _initNfc();
  }

  void _showNotSupport() {
    Message.show('该设备不支持NFC功能!');
  }

  Future<void> _initNfc() async {
    bool isSupport = true;
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
      String mainVersion = info.systemVersion.split('.')[0];
      double version = double.parse(mainVersion);
      if (!info.isPhysicalDevice || version < 13.0) {
        isSupport = false;
      }
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (!info.isPhysicalDevice || info.version.sdkInt < 19.0) {
        isSupport = false;
      }
    }

    if (!isSupport) {
      _showNotSupport();
      return;
    }

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
              child: Image.asset(
                'assets/images/nfc.png',
                width: width,
                height: width,
              ),
            ),
            const Text(
              '请将NFC标签或者贴纸靠近手机背面',
              style: TextStyle(fontSize: 18, color: FcColor.punch),
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: HandleButton(
          backgroundColor: FcColor.punch,
          onPressed: () {
            NfcManager.instance.stopSession();
            widget.param.way = InspectionWay.nfc;
            Navigator.pushNamed(context, PunchErrorPage.routeName, arguments: widget.param)
                .then((value) {
              if (value != null) {
                Navigator.pop(context, value);
              } else {
                _initNfc();
              }
            });
          },
          title: 'NFC异常?',
        ),
      ),
    );
  }
}

///扫码打卡
class ScanPunchPage extends StatelessWidget {
  static const routeName = '/scanPunch';

  final PunchParam param;

  const ScanPunchPage({super.key, required this.param});

  @override
  Widget build(BuildContext context) {
    bool isPunching = false;
    ScanController controller = ScanController();
    return Scan(
      controller: controller,
      onDetect: (capture) {
        if (isPunching) return;
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          Barcode barcode = barcodes[0];
          debugPrint('Barcode found! ${barcode.rawValue}');
          param.code = barcode.rawValue;
          isPunching = true;
          TaskApi.punch(param).then((value) {
            isPunching = false;
            if (value.code == 200) {
              // 打卡成功
              PunchResult result = PunchResult.fromJson(value.data);
              Navigator.pop(context, result);
            }
          }, onError: (e) {
            isPunching = false;
          });
        }
      },
      footer: HandleButton(
        backgroundColor: FcColor.punch,
        onPressed: () {
          controller.stop();
          param.way = InspectionWay.qrcode;
          Navigator.pushNamed(context, PunchErrorPage.routeName, arguments: param)
              .then((value) {
                if (value != null) {
                  Navigator.pop(context, value);
                } else {
                  controller.start();
                }
          });
        },
        title: '扫码异常?',
      ),
    );
  }
}

class PunchErrorPage extends StatefulWidget {
  static const routeName = '/punchError';

  final PunchParam param;

  const PunchErrorPage({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _PunchErrorPageState();
}

class _PunchErrorPageState extends State<PunchErrorPage> {
  final List<_ErrorItem> _nfcItems = [
    _ErrorItem(1, '找不到NFC'),
    _ErrorItem(2, 'NFC损坏'),
    _ErrorItem(3, '网络异常'),
    _ErrorItem(9, '其他'),
  ];

  final List<_ErrorItem> _qrCodeItems = [
    _ErrorItem(1, '找不到二维码'),
    _ErrorItem(2, '二维码损坏'),
    _ErrorItem(3, '网络异常'),
    _ErrorItem(9, '其他'),
  ];

  String _remark = '';
  int? _select;

  @override
  void initState() {
    super.initState();
    widget.param.code = null;
  }

  @override
  void dispose() {
    super.dispose();
    widget.param.remark = null;
  }

  @override
  Widget build(BuildContext context) {
    bool isPunching = false;
    List<_ErrorItem> items = [];
    if (widget.param.way == InspectionWay.nfc) {
      items = _nfcItems;
    } else if (widget.param.way == InspectionWay.qrcode) {
      items = _qrCodeItems;
    }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: const Text('异常原因'),
      ),
      // backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListView.separated(
              separatorBuilder: (ctx, index) => Divider(),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                _ErrorItem item = items[index];

                IconData iconData = Icons.circle_outlined;
                if (_select == item.value) {
                  iconData = Icons.check_circle_outline;
                }
                Icon icon = Icon(iconData);

                return ListTile(
                  title: Text(item.description),
                  trailing: icon,
                  selected: _select == item.value,
                  onTap: () {
                    _select = item.value;
                    if (_select == 9) {
                      //其他
                      _remark = '';
                    } else {
                      _remark = item.description;
                    }
                    setState(() {});
                  },
                );
              },
            ),
            if (_select == 9)
              Column(
                children: [
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 11, right: 16),
                        child: Text(
                          '异常原因',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          minLines: 3,
                          maxLines: null,
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            // focusedBorder: InputBorder.none,
                            // enabledBorder: InputBorder.none,
                            hintText: '请输入原因',
                          ),
                          onChanged: (value) {
                            _remark = value;
                          },
                        ),
                      )
                    ],
                  )
                ],
              )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: HandleButton(
            onPressed: () {
              if (isPunching) return;
              if (_remark.isEmpty) {
                Message.show('请选择异常原因');
                return;
              }
              widget.param.remark = _remark;
              TaskApi.punch(widget.param).then((value) {
                isPunching = false;
                if (value.code == 200) {
                  // 打卡成功
                  PunchResult result = PunchResult.fromJson(value.data);
                  result.remark = _remark;
                  Navigator.pop(context, result);
                }
              }, onError: (e) {
                isPunching = false;
              });
            },
            title: '确认打卡',
          ),
        ),
      ),
    );
  }
}

class _ErrorItem {
  int value;
  String description;

  _ErrorItem(this.value, this.description);
}
