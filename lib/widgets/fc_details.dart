import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:flutter/material.dart';

/// 详情页骨架
class FcDetailPage extends StatelessWidget {
  final String title;
  final List<Widget> body;
  final List<Widget>? footer;
  final List<Widget>? actions;
  final bool? loadingState;
  final bool? roll;

  const FcDetailPage(
      {super.key,
      required this.title,
      this.body = const <Widget>[],
      this.actions = const <Widget>[],
      this.loadingState = true,
      this.roll = true,
      this.footer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0.5,
          title: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          // backgroundColor: FcColor.bodyTitleColor,
          actions: actions,
        ),
        backgroundColor: FcColor.bodyColor,
        body: loadingState == false
            ? const Loading()
            : roll == true
                ? SingleChildScrollView(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: body,
                  ))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: body,
                  ),
        bottomNavigationBar: _buildFooter());
  }

  Widget? _buildFooter() {
    if (footer != null && footer!.isNotEmpty) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          // height: 66.0,
          child: Row(
            children: footer!,
          ),
        ),
      );
    }
    return null;
  }
}

// 加载中
class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(
                color: Color(0xFF1976D2),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14),
                child: Text(
                  '数据加载中',
                  style: TextStyle(fontSize: 14.0, color: Color(0xFF1976D2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
  final String? text;

  const LocationButton({super.key, required this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(FcColor.barMineColor),
          foregroundColor: MaterialStateProperty.all(FcColor.err),
          side: MaterialStateProperty.all(
              const BorderSide(color: FcColor.err, width: 1)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 12)),
          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      child: Text(text ?? '地图位置'),
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
          backgroundColor: MaterialStateProperty.all(FcColor.err),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
              const BorderSide(color: FcColor.err, width: 1)),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 12)),
          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      child: Text(title),
    );
  }
}

/// 信息状态
class InfoStatus extends StatelessWidget {
  final String? processingText;
  final String? endedText;

  const InfoStatus({
    super.key,
    this.processingText,
    this.endedText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      processingText ?? endedText ?? '',
      style: TextStyle(color: endedText != null ? FcColor.ok : FcColor.err),
    );
  }
}
