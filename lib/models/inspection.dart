import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';

class RouteResponse extends Response<InspectionRoute> {
  RouteResponse.fromJson(Map<String, dynamic> json)
      : super(
            json['currentPage'],
            json['totalRow'],
            json['totalPage'],
            (json['result'] as List)
                .map((e) => InspectionRoute.fromJson(e))
                .toList());
}

class RouteParam extends Param {
  int status;

  RouteParam({this.status = 1}) : super();

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'status': status
    };
    map.addAll(super.toJson());
    return map;
  }
}

class InspectionRoute {
  int amount;
  int canReceive;
  int finishedAmount;
  int? limitedTime;
  String name;
  int nodeCount;
  InspectionWay way;
  int receiveSum;
  int taskId;
  InspectionType type;
  String unitName;

  InspectionRoute.fromJson(Map<String, dynamic> json)
      : amount = json['amount'] ?? 0,
        canReceive = json['canReceive'],
        finishedAmount = json['finishedAmount'],
        limitedTime = json['limitedTime'],
        name = json['name'],
        nodeCount = json['nodeCount'],
        way = InspectionWayExtension.byValue(json['planType']),
        receiveSum = json['receiveSum'],
        taskId = json['taskId'],
        type = InspectionTypeExtension.byValue(json['type']),
        unitName = json['unitName'];

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'canReceive': canReceive,
        'finishedAmount': finishedAmount,
        'limitedTime': limitedTime,
        'name': name,
        'nodeCount': nodeCount,
        'planType': way.value,
        'receiveSum': receiveSum,
        'taskId': taskId,
        'type': type.value,
        'unitName': unitName
      };
}

enum InspectionWay {
  all,
  qrcode,
  nfc
}

extension InspectionWayExtension on InspectionWay {
  static InspectionWay byValue(int? value) {
    if (value == null) return InspectionWay.all;
    return InspectionWay.values[value];
  }

  int? get value {
    if (this == InspectionWay.all) return null;
    return index;
  }

  String get desc {
    switch(this) {
      case InspectionWay.all:
        return "??????";
      case InspectionWay.qrcode:
        return "?????????";
      case InspectionWay.nfc:
        return "NFC";
    }
  }
}

enum InspectionType {
  report,
  activity,
  check,
  review,
  build,
  remove,
  resume,
  other
}

extension InspectionTypeExtension on InspectionType {
  static InspectionType byValue(int value) {
    return InspectionType.values[value - 1];
  }

  int? get value {
    return index + 1;
  }

  String get desc {
    switch(this) {
      case InspectionType.report:
        return "????????????";
      case InspectionType.activity:
        return "????????????";
      case InspectionType.check:
        return "????????????";
      case InspectionType.review:
        return "??????";
      case InspectionType.build:
        return "????????????";
      case InspectionType.remove:
        return "??????????????????";
      case InspectionType.resume:
        return "??????????????????";
      case InspectionType.other:
        return "????????????";
    }
  }
}