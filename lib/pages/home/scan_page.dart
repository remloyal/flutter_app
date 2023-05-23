
import 'package:fire_control_app/pages/login/login.dart';
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
            if (state.isLogin) return;
            state.isLogin = true;
            _processLogin(context, url, state, controller);
          }
        }
      },
    );
  }

  void _processLogin(BuildContext context, String url, _ScanState state, ScanController controller) {
    controller.stop();
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
}

class _ScanState {
  //是否正在登陆
  bool isLogin = false;
  //是否控制室打卡
  bool isControl = false;
  //是否上下班打卡
  bool isWork = false;
}
