import 'package:fire_control_app/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fire_control_app/common/fc_icon.dart';

class MarkerParam {
  String type;
  List<double> point;

  Color? style;
  IconData? icon;
  String? tip;
  String? title;

  Color? bgcolor;
  Color? iconColor;

  Color? alarmStyle;
  Color? faultStyle;

  MarkerParam({
    required this.type,
    required this.point,
    this.style = Colors.red,
    this.title = '',
    this.tip = '',
    this.icon,
    this.bgcolor = Colors.black,
    this.iconColor = Colors.white,
    this.alarmStyle,
    this.faultStyle,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'point': point,
        'drop': LatLng(point[1], point[0]),
        'title': title,
        'icon': icon,
        'style': style,
        'tip': tip,
        'bgcolor': bgcolor,
        'iconColor': iconColor,
        'alarmStyle': alarmStyle,
        'faultStyle': faultStyle,
      };
}

class MarkerTypes {
  static MarkerParam fire = MarkerParam(
      point: [],
      type: 'fire',
      style: const Color(0XFFE53935),
      icon: MsgIcon.fire,
      iconColor: const Color(0xffffffff),
      tip: "发生火情，请及时处理",
      title: '发生火情');

  static MarkerParam alarm = MarkerParam(
      point: [],
      type: 'alarm',
      style: const Color(0XFFFF9800),
      icon: const IconData(0xe6d3, fontFamily: 'fcm'),
      tip: "发生报警，请及时处理",
      iconColor: const Color(0XFFE53935),
      title: '发生报警');

  static MarkerParam trouble = MarkerParam(
      point: [],
      type: 'trouble',
      style: const Color(0XFFFF9800),
      icon: const IconData(0xe637, fontFamily: 'fcm'),
      iconColor: const Color(0XFFffffff),
      title: '发现隐患');

  static MarkerParam danger = MarkerParam(
      point: [],
      type: 'danger',
      style: const Color(0XFFFF9800),
      icon: const IconData(0xe69d, fontFamily: 'fcm'),
      iconColor: const Color(0XFFffffff),
      title: '发现危险品');

  static MarkerParam fault = MarkerParam(
      point: [],
      type: 'fault',
      icon: const IconData(0xe612, fontFamily: 'fcm'),
      style: const Color(0XFFFFCC80),
      iconColor: const Color(0XFFffffff),
      tip: "设备故障，请及时处理",
      title: '发生故障');

  static MarkerParam unit = MarkerParam(
    point: [],
    type: 'unit',
    icon: const IconData(0xe675, fontFamily: 'fcm'),
    style: const Color(0XFF1976D2),
  );

  static MarkerParam build = MarkerParam(
    point: [],
    type: 'build',
    icon: const IconData(0xe675, fontFamily: 'fcm'),
    style: const Color(0XFF1976D2),
  );

  static MarkerParam device = MarkerParam(
    point: [],
    type: 'device',
    style: const Color(0xff008FB3),
    alarmStyle: const Color(0xfff53f3f),
    faultStyle: const Color(0xffFAB736),
  );
}

class MapPoint {
  // 单位
  static Marker unit(Unit unit) {
    return Marker(
      width: 220,
      height: 50,
      // rotateOrigin: Offset(-125, 125),
      point: LatLng(unit.pointY, unit.pointX),
      builder: (ctx) {
        return Stack(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Color(0xffC2DA37),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
                  child: Text(
                    unit.score.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 1),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Color(0xffD2D2D2),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                  child: Text(
                    unit.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 36,
                left: 42,
                child: Container(
                  width: 0,
                  height: 0,
                  decoration: const BoxDecoration(
                    border: Border(
                      // 四个值 top right bottom left
                      // top: BorderSide(color: Colors.white, width: 12, style: BorderStyle.solid),
                      right: BorderSide(color: Colors.transparent, width: 12, style: BorderStyle.solid),
                      left: BorderSide(color: Colors.transparent, width: 12, style: BorderStyle.solid),
                      bottom: BorderSide(color: Color(0xFFD2D2D2), width: 12, style: BorderStyle.solid),
                    ),
                  ),
                ))
          ],
        );
      },
    );
  }

  // 火情
  static file(MarkerParam data, {bool maker = true, Color titleColor = Colors.black}) {
    Widget lead = Column(children: [
      Center(
          child: Text(
        data.title!,
        style: TextStyle(color: titleColor),
      )),
      Stack(children: [
        Icon(
          const IconData(0xe62E, fontFamily: 'fcm'),
          color: data.style,
          size: 40,
        ),
        Positioned(
          top: 6,
          left: 10,
          child: Icon(
            data.icon,
            size: 20,
            color: data.iconColor,
          ),
        )
      ]),
    ]);

    if (maker) {
      return Marker(
        width: 50,
        height: 150,
        point: LatLng(data.point[0], data.point[1]),
        builder: (ctx) {
          return lead;
        },
      );
    } else {
      return lead;
    }
  }

  // 火情圈
  static fileCircle(LatLng latLng) {
    return CircleMarker(
      point: latLng,
      radius: 600,
      color: const Color(0x33F44336),
      borderStrokeWidth: 1,
      borderColor: Colors.red,
      useRadiusInMeter: true,
    );
  }
}

//直角三角形
// Container(
//                     child: CustomPaint(
//                       painter: RightTrianglePainter(),
//                       size: Size(50, 50), // 设置三角形的大小
//                     ),
//                   )
// class RightTrianglePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;

//     final path = Path();
//     // path.moveTo(0, size.height); // 左下角
//     // path.lineTo(size.width, size.height); // 右下角
//     // path.lineTo(0, 0); // 左上角
//     // path.close(); // close path
//     path.add();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(RightTrianglePainter oldDelegate) => false;
// }
