import 'package:flutter/material.dart';
import 'package:fire_control_app/http/login_api.dart';

class Mine extends StatelessWidget {
  const Mine({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        print('object');
        LoginService.clearInfo();
      },
    );
  }
}
