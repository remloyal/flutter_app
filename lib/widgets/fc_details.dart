import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/material.dart';

/// 详情页骨架
class FcDetailPage extends StatelessWidget {
  final String title;
  final List<Widget> body;
  final List<Widget>? footer;

  const FcDetailPage(
      {super.key,
      required this.title,
      this.body = const <Widget>[],
      this.footer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: FcColor.bodyColor,
        ),
        backgroundColor: FcColor.bodyColor,
        body: SingleChildScrollView(
          child: Column(
            children: body,
          ),
        ),
        bottomNavigationBar: _buildFooter());
  }

  Widget? _buildFooter() {
    if (footer != null) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 76.0,
          child: Row(
            children: footer!,
          ),
        ),
      );
    }
    return null;
  }
}

/// 联动监控
class AssociateVideos extends StatelessWidget {
  final List<CameraInfo> videos;

  const AssociateVideos({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const CardHeader(title: "联动监控"),
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: videos.map((e) => _buildVideoItem(e)).toList(),
        ),
      ],
    );
  }

  Widget _buildVideoItem(CameraInfo info) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: FcColor.bodyColor,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(info.name),
            ),
            const Icon(
              Icons.play_circle_outline,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}

/// 地图位置button
class LocationButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LocationButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(FcColor.barMineColor),
          side: MaterialStateProperty.all(
              const BorderSide(color: Colors.red, width: 1)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      child: const Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Text(
          "地图位置",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

/// 处理的button
class HandleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final String title;

  const HandleButton({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
          side: MaterialStateProperty.all(
              const BorderSide(color: Colors.red, width: 1)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Text(title, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

/// 信息状态
class InfoStatus extends StatelessWidget {

  final String? processingText;
  final String? endedText;

  const InfoStatus({super.key, this.processingText, this.endedText,});

  @override
  Widget build(BuildContext context) {
    return Text(
      processingText ?? endedText ?? '',
      style: TextStyle(
          color: endedText != null ? FcColor.ok : FcColor.err),
    );
  }
}
