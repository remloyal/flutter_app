import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';

// 路线
class RouteResponse extends ListResponse<RouteItem> {
  RouteResponse.fromJson(super.json) : super.fromJson();

  @override
  RouteItem generateRecord(Map<String, dynamic> data) =>
      RouteItem.fromJson(data);
}

class RouteParam extends Param {
  int status;
  int? type;
  int? planType;

  RouteParam({this.status = 1}) : super();

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'status': status,
      'type': type,
      'planType': planType,
    };
  }
}

class RouteItem {
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

  RouteItem.fromJson(Map<String, dynamic> json)
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

  int get value {
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
class PlanResponse extends ListResponse<TaskItem> {
  PlanResponse.fromJson(super.json) : super.fromJson();

  @override
  TaskItem generateRecord(Map<String, dynamic> data) => TaskItem.fromJson(data);
}

class TaskItem {
  int taskId;
  String name;
  String unitName;
  InspectionType type;
  int? userId;
  String userName;
  InspectionWay planType;
  int totalNode;
  int finishTotalNode;
  String receiveTime;
  int status;
  String? finishedTime;
  int? limitedTime;
  String idCode;

  TaskItem.fromJson(Map<String, dynamic> json)
      : taskId = json['taskId'],
        name = json['name'],
        unitName = json['unitName'],
        type = InspectionTypeExtension.byValue(json['type']),
        userId = json['userId'],
        userName = json['userName'],
        planType = InspectionWayExtension.byValue(json['planType']),
        totalNode = json['totalNode'],
        finishTotalNode = json['finishTotalNode'],
        receiveTime = json['receiveTime'],
        status = json['status'],
        finishedTime = json['finishedTime'],
        limitedTime = json['limitedTime'],
        idCode = json['idCode'];

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

class TaskParam extends RouteParam with TimeParam, KeywordParam {
  TaskParam() : super();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'keyword': keyword,
      };
}

class TaskDetail extends TaskItem {
  List<InspectionNode>? nodes;

  TaskDetail.fromJson(Map<String, dynamic> json)
      : nodes = json['nodes']
            ?.map((v) => InspectionNode.fromJson(v))
            .toList()
            .cast<InspectionNode>(),
        super.fromJson(json);
}

class InspectionNode {
  String location;
  int nodeId;
  String? punchTime;
  String remark;
  int? status;

  InspectionNode.fromJson(Map<String, dynamic> json)
      : location = json['location'],
        nodeId = json['nodeId'],
        punchTime = json['punchTime'],
        remark = json['remark'] ?? '',
        status = json['status'];
}

class RouteDetail extends RouteItem {
  List<InspectionNode>? nodes;

  RouteDetail.fromJson(super.json)
      : nodes = json['nodes']
            ?.map((v) => InspectionNode.fromJson(v))
            .toList()
            .cast<InspectionNode>(),
        super.fromJson();
}

class PunchParam {
  int taskId;
  int nodeId;
  String? code;
  InspectionWay? way;
  String? remark;

  PunchParam({required this.taskId, required this.nodeId});

  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'nodeId': nodeId,
    'code': code,
    'remark': remark,
  };
}

class PunchResult {
  String time;
  int finish;
  String? remark;

  PunchResult.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        finish = json['finish'];
}