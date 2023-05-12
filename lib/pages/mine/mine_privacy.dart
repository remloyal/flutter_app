// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:fire_control_app/widgets/view/FakeUi.dart'
// if (dart.library.html) 'RealUi.dart' as ui;

class MinePrivacy extends StatefulWidget {
  const MinePrivacy({super.key, this.index = 1});
  final int index;
  @override
  State<MinePrivacy> createState() => _MinePrivacyState();
}

class _MinePrivacyState extends State<MinePrivacy> {
  late WebViewController? controller;
  late bool loadingState = false;
  late int index = 1;
  final String agreement = 'https://stdos.zhxf.ltd/app/privacy.html';
  final String privacy = 'https://stdos.zhxf.ltd/app/agreement.html';

  @override
  void initState() {
    index = widget.index;
    String url = index == 1 ? privacy : agreement;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(url));
    super.initState();
    loadingState = true;
    setState(() {});
  }

  setUrl(int key) {
    index = key;
    String url = index == 1 ? privacy : agreement;
    setState(() {
      controller!.loadRequest(Uri.parse(url));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '协议政策',
      roll: false,
      loadingState: loadingState,
      body: [
        Container(
          height: 40,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Color.fromARGB(255, 206, 206, 206)))),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setUrl(1);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: index == 1
                      ? const Color.fromARGB(255, 233, 233, 233)
                      : Colors.white,
                  child: const Center(
                    child: Text('服务协议'),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setUrl(2);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: index == 2
                      ? const Color.fromARGB(255, 233, 233, 233)
                      : Colors.white,
                  child: const Center(
                    child: Text('隐私政策'),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (controller != null)
          Expanded(child: WebViewWidget(controller: controller!))
      ],
    );
  }
}
