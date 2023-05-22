import 'package:fire_control_app/common/fc_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scan extends StatefulWidget {
  final ValueChanged<BarcodeCapture> onDetect;

  final ScanController? controller;

  final Widget? footer;

  const Scan({super.key, required this.onDetect, this.footer, this.controller});

  @override
  State<StatefulWidget> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(torchEnabled: false, autoStart: false);
    _bindController();
    _start();
  }

  _start() {
    _controller.start().then((value) {}, onError: (e) {
      MobileScannerException exception = e as MobileScannerException;
      if (exception.errorCode == MobileScannerErrorCode.permissionDenied) {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('提示'),
                content: const Text('请在系统设置中先启用摄像头功能'),
                actions: [
                  TextButton(
                    child: const Text('确认'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    });
  }

  void _stop() {
    _controller.stop();
  }
  _bindController() {
    widget.controller?._start = _start;
    widget.controller?._stop = _stop;
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller?._start = null;
    widget.controller?._stop = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    double length = data.size.width * 2 / 3;
    double offset = data.padding.top + kToolbarHeight;
    final scanWindow = Rect.fromCenter(
        center: data.size.center(Offset(0, -offset)),
        width: length,
        height: length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('扫一扫'),
        actions: [
          IconButton(
            onPressed: () {
              _controller.toggleTorch();
            },
            icon: const Icon(FcmIcon.light),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            // fit: BoxFit.contain,
            controller: _controller,
            scanWindow: scanWindow,
            onDetect: widget.onDetect,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: _ScanAnimation(),
          )
        ],
      ),
      bottomNavigationBar: widget.footer == null
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.all(widget.footer == null ? 0 : 10.0),
                child: widget.footer,
              ),
            ),
    );
  }
}

class _ScanAnimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanAnimationState();
}

class _ScanAnimationState extends State<_ScanAnimation>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  final Tween<double> _tween = Tween(begin: 0.05, end: 0.95);

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _animation = _tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanPainter(ratio: _animation.value),
      child: Container(),
    );
  }
}

class _ScanPainter extends CustomPainter {
  final double ratio;

  _ScanPainter({required this.ratio});

  @override
  void paint(Canvas canvas, Size size) {
    // 计算扫描框位置
    double length = size.width * 2 / 3;
    double left = (size.width - length) / 2;
    double top = (size.height - length) / 2;

    Rect rect = Rect.fromLTWH(left, top, length, length);
    Offset topLeft = rect.topLeft;
    Offset bottomLeft = rect.bottomLeft;
    Offset topRight = rect.topRight;
    Offset bottomRight = rect.bottomRight;

    // 定义画笔
    //绘制蒙板
    Paint paint = Paint()
      ..color = const Color(0x50000000)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTRB(0, 0, left, size.height), paint);
    canvas.drawRect(
        Rect.fromLTRB(topLeft.dx, 0, topRight.dx, topLeft.dy), paint);
    canvas.drawRect(
        Rect.fromLTRB(topRight.dx, 0, size.width, size.height), paint);
    canvas.drawRect(
        Rect.fromLTRB(
            bottomLeft.dx, bottomLeft.dy, bottomRight.dx, size.height),
        paint);

    // 绘制扫描框
    const double cornerLength = 20.0;
    paint
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
    Offset hOffset = const Offset(cornerLength, 0);
    Offset vOffset = const Offset(0, cornerLength);
    canvas.drawLine(topLeft, topLeft + hOffset, paint);
    canvas.drawLine(topLeft, topLeft + vOffset, paint);

    canvas.drawLine(topRight, topRight - hOffset, paint);
    canvas.drawLine(topRight, topRight + vOffset, paint);

    canvas.drawLine(bottomLeft, bottomLeft + hOffset, paint);
    canvas.drawLine(bottomLeft, bottomLeft - vOffset, paint);

    canvas.drawLine(bottomRight, bottomRight - hOffset, paint);
    canvas.drawLine(bottomRight, bottomRight - vOffset, paint);

    // 绘制扫描线
    paint.strokeWidth = 2;
    double offsetY = top + length * ratio;
    canvas.drawLine(Offset(topLeft.dx + 10, offsetY),
        Offset(topRight.dx - 10, offsetY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ScanController {

  VoidCallback? _start;
  VoidCallback? _stop;

  void start() {
    if (_start != null) {
      _start!();
    }
  }

  void stop() {
    if (_stop != null) {
      _stop!();
    }
  }
}