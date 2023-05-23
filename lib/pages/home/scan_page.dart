
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/pages/login/login.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatelessWidget {
  static const routeName = '/scan';

  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScanController controller = ScanController();
    _ScanState state = _ScanState();
    return Scan(
      controller: controller,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          Barcode barcode = barcodes[0];
          debugPrint('Barcode found! ${barcode.rawValue}');
          if (barcode.rawValue == null) return;
          String url = barcode.rawValue!;
          if (url.contains('k=3')) {
            //扫码登陆
            _processLogin(context, url, state, controller);
          } else if (url.contains('k=2')) {
            //控制室打卡
            _processControlPunch(url, state);
          } else if (url.contains('k=4')) {
            //上下班打卡
            _processWorkPunch(url, state);
          }
        }
      },
    );
  }

  void _processLogin(BuildContext context, String url, _ScanState state, ScanController controller) {
    if (state.isLogin) return;
    controller.stop();
    state.isLogin = true;
    Navigator.pushNamed(context, LoginScanPage.routeName, arguments: url).then((value) {
      if (value != null && value as bool) {
        Navigator.pop(context);
      } else {
        state.isLogin = false;
        controller.start();
      }
    }, onError: (e) {
      state.isLogin = false;
      controller.start();
    });
  }

  void _processControlPunch(String url, _ScanState state) {
    if (state.isControl) return;
    state.isControl = true;
    TaskApi.controlPunch(url).then((value) {
      state.isControl = false;
      if (value.code == 200) {
        Message.show('打卡成功');
      }
    }, onError: (e) {
      state.isControl = false;
    });
  }

  void _processWorkPunch(String url, _ScanState state) {
    if (state.isWork) return;
    state.isWork = true;
    TaskApi.workPunch(url).then((value) {
      state.isWork = false;
      if (value.code == 200) {
        Message.show('打卡成功');
      }
    }, onError: (e) {
      state.isWork = false;
    });
  }
}

class _ScanState {
  //是否正在登陆
  bool isLogin = false;
  //是否控制室打卡
  bool isControl = false;
  //是否上下班打卡
  bool isWork = false;
}
