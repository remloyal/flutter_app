import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';
import 'package:flutter/material.dart';

// 路线
class RouteResponse extends Response<InspectionRoute> {
  RouteResponse(
      {super.currentPage,
      super.totalRow,
      super.totalPage,
      super.result,
      super.fromRow,
      super.needCount,
      super.orderByClause,
      super.pageSize});

  RouteResponse.fromJson(Map<String, dynamic> json)
      : super(
            currentPage: json['currentPage'],
            totalRow: json['totalRow'],
            totalPage: json['totalPage'],
            fromRow: json['fromRow'],
            needCount: json['needCount'],
            orderByClause: json['orderByClause'],
            pageSize: json['pageSize'],
            result: (json['result'] as List)
                .map((e) => InspectionRoute.fromJson(e))
                .toList());

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPage': totalPage,
        'totalRow': totalRow,
        'pageSize': pageSize,
        'orderByClause': orderByClause,
        'needCount': needCount,
        'result': result,
        'fromRow': fromRow,
      };
}

class RouteParam extends Param with ChangeNotifier {
  int status;

  RouteParam({this.status = 1}) : super();

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'status': status};
    map.addAll(super.toJson());
    return map;
  }

  void change() {
    notifyListeners();
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
class PlanCase extends Response<PlanResult> {
  PlanCase(
      {super.currentPage,
      super.totalRow,
      super.totalPage,
      super.result,
      super.fromRow,
      super.needCount,
      super.orderByClause,
      super.pageSize});

  PlanCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <PlanResult>[];
      json['result'].forEach((v) {
        result!.add(PlanResult.fromJson(v));
      });
    }
    fromRow = json['fromRow'];
  }

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPage': totalPage,
        'totalRow': totalRow,
        'pageSize': pageSize,
        'orderByClause': orderByClause,
        'needCount': needCount,
        'result': result,
        'fromRow': fromRow,
      };
}

class PlanResult {
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

  PlanResult(
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

  PlanResult.fromJson(Map<String, dynamic> json) {
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

class PlanParam extends Param with ChangeNotifier {
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

  void change() {
    notifyListeners();
  }
}
