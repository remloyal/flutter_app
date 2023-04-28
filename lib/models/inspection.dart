import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';

// 路线
class RouteResponse extends ListResponse<InspectionRoute> {
  RouteResponse.fromJson(super.json) : super.fromJson();

  @override
  InspectionRoute generateRecord(Map<String, dynamic> data) =>
      InspectionRoute.fromJson(data);
}

class RouteParam extends Param {
  int status;

  RouteParam({this.status = 1}) : super();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'status': status
    };
  }
}

class InspectionRoute implements ListItemData {
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

enum InspectionWay { all, qrcode, nfc }

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
    switch (this) {
      case InspectionWay.all:
        return "全部";
      case InspectionWay.qrcode:
        return "二维码";
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
    switch (this) {
      case InspectionType.report:
        return "举报核查";
      case InspectionType.activity:
        return "活动检查";
      case InspectionType.check:
        return "例行检查";
      case InspectionType.review:
        return "复查";
      case InspectionType.build:
        return "施工检查";
      case InspectionType.remove:
        return "解除临时查封";
      case InspectionType.resume:
        return "恢复工作检查";
      case InspectionType.other:
        return "其他检查";
    }
  }
}

// 任务
class PlanResponse extends ListResponse<InspectionPlan> {
  PlanResponse.fromJson(super.json) : super.fromJson();

  @override
  InspectionPlan generateRecord(Map<String, dynamic> data) =>
      InspectionPlan.fromJson(data);
}

class InspectionPlan extends ListItemData{
  late int taskId;
  late String name;
  late String unitName;
  late InspectionType type;
  late int userId;
  late String userName;
  late InspectionWay planType;
  late int totalNode;
  late int finishTotalNode;
  late String receiveTime;
  late int status;
  late dynamic finishedTime;
  late int? limitedTime;
  late String idCode;

  InspectionPlan(
      {taskId,
      name,
      unitName,
      type,
      userId,
      userName,
      planType,
      totalNode,
      finishTotalNode,
      receiveTime,
      status,
      finishedTime,
      limitedTime,
      idCode});

  InspectionPlan.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    name = json['name'];
    unitName = json['unitName'];
    type = InspectionTypeExtension.byValue(json['type']);
    userId = json['userId'];
    userName = json['userName'];
    planType = InspectionWayExtension.byValue(json['planType']);
    totalNode = json['totalNode'];
    finishTotalNode = json['finishTotalNode'];
    receiveTime = json['receiveTime'];
    status = json['status'];
    finishedTime = json['finishedTime'];
    limitedTime = json['limitedTime'];
    idCode = json['idCode'];
  }

  Map<String, dynamic> toJson() => {
        'taskId': taskId,
        'name': name,
        'unitName': unitName,
        'type': type,
        'userId': userId,
        'userName': userName,
        'planType': planType,
        'totalNode': totalNode,
        'finishTotalNode': finishTotalNode,
        'receiveTime': receiveTime,
        'status': status,
        'finishedTime': finishedTime,
        'limitedTime': limitedTime,
        'idCode': idCode,
      };
}

class PlanParam extends Param {
  int status = 1;
  dynamic keyword;
  dynamic beginTime;
  dynamic endTime;
  dynamic type;
  dynamic planType;

  PlanParam() : super();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'keyword': keyword,
        'status': status,
        'type': type,
        'planType': planType,
      };
}
