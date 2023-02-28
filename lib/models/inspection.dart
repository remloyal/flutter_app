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
  int planType;
  int receiveSum;
  int taskId;
  int type;
  String unitName;

  InspectionRoute.fromJson(Map<String, dynamic> json)
      : amount = json['amount'] ?? 0,
        canReceive = json['canReceive'],
        finishedAmount = json['finishedAmount'],
        limitedTime = json['limitedTime'],
        name = json['name'],
        nodeCount = json['nodeCount'],
        planType = json['planType'],
        receiveSum = json['receiveSum'],
        taskId = json['taskId'],
        type = json['type'],
        unitName = json['unitName'];

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'canReceive': canReceive,
        'finishedAmount': finishedAmount,
        'limitedTime': limitedTime,
        'name': name,
        'nodeCount': nodeCount,
        'planType': planType,
        'receiveSum': receiveSum,
        'taskId': taskId,
        'type': type,
        'unitName': unitName
      };
}
