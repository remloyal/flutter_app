import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MineExternalDetails extends StatefulWidget {
  const MineExternalDetails({
    super.key,
    required this.url,
    required this.type,
  });
  final String url;
  final String type;

  @override
  State<MineExternalDetails> createState() => _MineExternalDetailsState();
}

class _MineExternalDetailsState extends State<MineExternalDetails> {
  late WebViewController? controller;
  late bool loadingState = false;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
    loadingState = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: widget.type == 'news' ? '新闻详情' : '帮助详情',
      roll: false,
      loadingState: loadingState,
      body: [
        if (controller != null)
          Expanded(child: WebViewWidget(controller: controller!))
      ],
    );
  }
}
