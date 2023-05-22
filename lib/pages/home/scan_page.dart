import 'dart:typed_data';

import 'package:fire_control_app/widgets/scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatelessWidget {
  static const routeName = '/scan';

  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scan(
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        for (final barcode in barcodes) {
          debugPrint('Barcode found! ${barcode.rawValue}');
        }
      },
    );
  }
}
