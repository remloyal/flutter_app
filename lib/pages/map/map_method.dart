import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fire_control_app/common/fc_icon.dart';

// 地图信息
class MapInfo extends ChangeNotifier {
  // 地图处理类型
  MapType? type;

  Unit? unit;
  Map? building;
  Map? floor;
  Map? room;
  List<double>? point;
  String? pointRate;

  String textName = '';

  int typeIndex = 0;

  // 需渲染的点
  List<Marker> lbsList = [];

  // 火情圈
  List<CircleMarker> circle = [];

  // 平面图点
  String? svgUrl;
  List<MarkerParam> planMarkers = [];

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'building': building,
        'floor': floor,
        'room': room,
        'textName': textName,
        'point': point,
        'pointRate': pointRate,
        'type': type,
        'typeIndex': typeIndex,
        'lbsList': lbsList,
        "svgUrl": svgUrl,
        "planMarkers": planMarkers
      };

  initText() {
    if (building != null) {
      textName = building!['name'];
    }
    if (floor != null) {
      textName = '$textName - ${floor!['name']}';
    }
    if (room != null) {
      textName = '$textName - ${room!['name']}';
    }
  }

  setPoint(List<double> data) {
    point = data;
    notifyListeners();
  }

  setUnnit(int id) {
    unit = Global.units.firstWhere((element) => element.unitId == id);
    Marker point = MapPoint.unit(unit!);
    lbsList.add(point);
  }

  setDevice(List<LbsInfo> data) {
    for (var i = 0; i < data.length; i++) {
      LbsInfo item = data[i];
      // 设备
      if (data[i].extensions.deviceType != null) {
        DeviceIcon icon = Global.deviceIcons.firstWhere((element) => element.type == item.extensions.deviceType);
        MarkerParam maker = MarkerTypes.device();
        maker.point = [item.loc.coordinates[1], item.loc.coordinates[0]];
        maker.title = item.title;
        maker.icon = icon.iconData;
        maker.iconColor = setColor(icon.color.replaceAll('#', ''));
        Marker point = MapPoint.device(maker);
        lbsList.add(point);
      }
      // 人员
      if (item.extensions.phone != null) {
        print(item);
        MarkerParam maker = MarkerTypes.personnel();
        maker.point = [item.loc.coordinates[1], item.loc.coordinates[0]];
        maker.title = item.title;
        // data[5].extensions.userAvatar
        Marker point = MapPoint.personnel(maker, Global.profile.apiInfo.imgUrl + item.extensions.userAvatar!);
        lbsList.add(point);
      }
    }
  }

  setDeviceIcon(String icon) {
    int myCodePoint = int.parse('0x$icon');
    return IconData(myCodePoint, fontFamily: 'iconfont');
  }

  setColor(String color) {
    if (color.length == 3) {
      int codeColor = int.parse('0xff$color$color');
      return Color(codeColor);
    } else {
      int codeColor = int.parse('0xff$color');
      return Color(codeColor);
    }
  }

  setMainPoint(List<double> point, String type) async {
    Map planType = MarkerTypes.toJson();
    MarkerParam maker = planType[type]();
    if (type == 'fire') {
      maker.point = point;
      List trendsPoint = await MapPoint.file(maker);
      lbsList.add(trendsPoint[0]);
      circle.add(trendsPoint[1]);
    } else {
      maker.point = point;
      Marker trendsPoint = await MapPoint.matchMaker(
        maker,
      );
      lbsList.add(trendsPoint);
    }
  }

  setDevicePoint(List<double> point, int deviceType, {String title = ''}) async {
    DeviceIcon icon = Global.deviceIcons.firstWhere((element) => element.type == deviceType);
    MarkerParam maker = MarkerTypes.device();
    maker.point = point;
    maker.title = title;
    maker.icon = icon.iconData;
    maker.iconColor = setColor(icon.color.replaceAll('#', ''));
    Marker data = MapPoint.device(maker);
    lbsList.add(data);
  }

  setPlan(
    String url,
    List<double> point,
    String type, {
    String? title,
    Color? bgcolor,
    Color? iconColor,
  }) {
    Map planType = MarkerTypes.toJson();
    MarkerParam maker = planType[type]();
    svgUrl = url;
    maker.point = point;
    if (bgcolor != null) {
      maker.bgcolor = bgcolor;
    }
    if (iconColor != null) {
      maker.iconColor = iconColor;
    }
    title != null ? maker.title = title : '';
    planMarkers.add(maker);
  }
}

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
    this.bgcolor,
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
  static MarkerParam fire() {
    return MarkerParam(
        point: [],
        type: 'fire',
        bgcolor: const Color(0XFFE53935),
        icon: MsgIcon.fire,
        iconColor: const Color(0xffffffff),
        tip: "发生火情，请及时处理",
        title: '发生火情');
  }

  static MarkerParam alarm() {
    return MarkerParam(
        point: [],
        type: 'alarm',
        style: const Color(0XFFFF9800),
        icon: const IconData(0xe6d3, fontFamily: 'fcm'),
        tip: "发生报警，请及时处理",
        iconColor: const Color(0XFFE53935),
        title: '发生报警');
  }

  static MarkerParam trouble() {
    return MarkerParam(
        point: [],
        type: 'trouble',
        style: const Color(0XFFFF9800),
        icon: const IconData(0xe637, fontFamily: 'fcm'),
        iconColor: const Color(0XFFffffff),
        title: '发现隐患');
  }

  static MarkerParam danger() {
    return MarkerParam(
        point: [],
        type: 'danger',
        style: const Color(0XFFFF9800),
        icon: const IconData(0xe69d, fontFamily: 'fcm'),
        iconColor: const Color(0XFFffffff),
        title: '发现危险品');
  }

  static MarkerParam fault() {
    return MarkerParam(
        point: [],
        type: 'fault',
        icon: const IconData(0xe612, fontFamily: 'fcm'),
        style: const Color(0XFFFFCC80),
        iconColor: const Color(0XFFffffff),
        tip: "设备故障，请及时处理",
        title: '发生故障');
  }

  static MarkerParam unit() {
    return MarkerParam(
      point: [],
      type: 'unit',
      icon: const IconData(0xe675, fontFamily: 'fcm'),
      style: const Color(0XFF1976D2),
    );
  }

  static MarkerParam build() {
    return MarkerParam(
      point: [],
      type: 'build',
      icon: const IconData(0xe675, fontFamily: 'fcm'),
      style: const Color(0XFF1976D2),
    );
  }

  static MarkerParam device() {
    return MarkerParam(
      point: [],
      type: 'device',
      title: '',
      icon: const IconData(0xe632, fontFamily: 'fcm'),
      style: const Color(0xff008FB3),
      bgcolor: const Color(0xff008FB3),
      alarmStyle: const Color(0xfff53f3f),
      faultStyle: const Color(0xffFAB736),
    );
  }

  static MarkerParam personnel() {
    return MarkerParam(
      point: [],
      type: 'personnel',
      title: '',
      bgcolor: const Color(0xffffffff),
    );
  }

  static Map<String, dynamic> toJson() => {
        'fire': MarkerTypes.fire,
        'alarm': MarkerTypes.alarm,
        'trouble': MarkerTypes.trouble,
        "danger": MarkerTypes.danger,
        "fault": MarkerTypes.fault,
        "unit": MarkerTypes.unit,
        "build": MarkerTypes.build,
        "device": MarkerTypes.device
      };
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

  //通用点
  static matchMaker(MarkerParam data, {bool maker = true, Color titleColor = Colors.black}) {
    Widget lead = Column(children: [
      Center(
          child: Text(
        data.title != null ? data.title! : '',
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
        width: 150,
        height: 120,
        rotateOrigin: const Offset(-10, -10),
        point: LatLng(data.point[0], data.point[1]),
        builder: (ctx) {
          return lead;
        },
      );
    } else {
      return lead;
    }
  }

  // 火情
  static file(MarkerParam data, {bool maker = true, Color titleColor = Colors.black}) async {
    Widget lead = Column(children: [
      Center(
          child: Text(
        data.title != null ? data.title! : '',
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
      return [
        Marker(
          width: 150,
          height: 120,
          rotateOrigin: const Offset(-10, -10),
          point: LatLng(data.point[0], data.point[1]),
          builder: (ctx) {
            return lead;
          },
        ),
        await fileCircle(LatLng(data.point[0], data.point[1]))
      ];
    } else {
      return lead;
    }
  }

  // 火情圈
  static fileCircle(LatLng latLng) {
    return CircleMarker(
      point: latLng,
      radius: 350,
      color: const Color(0x33F44336),
      borderStrokeWidth: 1,
      borderColor: Colors.red,
      useRadiusInMeter: true,
    );
  }

  // 设备
  static device(MarkerParam data, {bool maker = true, Color titleColor = Colors.black}) {
    Widget lead = Column(children: [
      Center(
          child: Text(
        data.title!,
        style: TextStyle(color: titleColor),
      )),
      Stack(children: [
        Icon(
          const IconData(0xe62E, fontFamily: 'fcm'),
          color: data.bgcolor,
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
        width: 150,
        height: 120,
        rotateOrigin: const Offset(-10, -10),
        point: LatLng(data.point[0], data.point[1]),
        builder: (ctx) {
          return lead;
        },
      );
    } else {
      return lead;
    }
  }

  // 人员
  static personnel(MarkerParam data, String url, {bool maker = true, Color titleColor = Colors.black}) {
    Widget lead = Column(children: [
      Center(
          child: Text(
        data.title!,
        style: TextStyle(color: titleColor),
      )),
      Stack(children: [
        Icon(
          const IconData(0xe62E, fontFamily: 'fcm'),
          color: data.bgcolor,
          size: 40,
        ),
        Positioned(
            top: 4,
            left: 5,
            child: ClipOval(
              child: Image(
                image: NetworkImage(url),
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
            ))
      ]),
    ]);

    if (maker) {
      return Marker(
        width: 150,
        height: 120,
        rotateOrigin: const Offset(-10, -10),
        point: LatLng(data.point[0], data.point[1]),
        builder: (ctx) {
          return lead;
        },
      );
    } else {
      return lead;
    }
  }
}
