import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';
import 'package:flutter/material.dart';

class Info {
  String unitName;
  String nickName;
  String cellPhone;
  String roleName;
  String createTime;
  String reviewTime;
  String reviewer;
  String headImgUrl;
  int message;

  Info(
      {required this.unitName,
      required this.nickName,
      required this.cellPhone,
      required this.roleName,
      required this.createTime,
      required this.reviewTime,
      required this.reviewer,
      required this.headImgUrl,
      required this.message});

  Info.fromJson(Map<String, dynamic> json)
      : unitName = json['unitName'],
        nickName = json['nickName'],
        cellPhone = json['cellPhone'],
        roleName = json['roleName'],
        createTime = json['createTime'] ?? '',
        reviewTime = json['reviewTime'] ?? '',
        reviewer = json['reviewer'] ?? '',
        headImgUrl = json['headImgUrl'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
        'unitName': unitName,
        'nickName': nickName,
        'cellPhone': cellPhone,
        'roleName': roleName,
        'createTime': createTime,
        'reviewTime': reviewTime,
        'reviewer': reviewer,
        'headImgUrl': headImgUrl,
        'message': message,
      };
}

class MineMailItem {
  int id;
  String unitName;
  String nickName;
  String cellPhone;
  String roleName;
  String headImgUrl;
  String group;
  bool online;
  int onlineType;

  MineMailItem(
      {required this.id,
      required this.unitName,
      required this.nickName,
      required this.cellPhone,
      required this.roleName,
      required this.headImgUrl,
      required this.group,
      required this.online,
      required this.onlineType});

  MineMailItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unitName = json['unitName'],
        nickName = json['nickName'],
        cellPhone = json['cellPhone'],
        roleName = json['roleName'],
        headImgUrl = json['headImgUrl'],
        group = json['group'],
        online = json['online'],
        onlineType = json['onlineType'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'unitName': unitName,
        'nickName': nickName,
        'cellPhone': cellPhone,
        'roleName': roleName,
        'headImgUrl': headImgUrl,
        'group': group,
        'online': online,
        'onlineType': onlineType,
      };
}

class MineWorkCommon with ChangeNotifier {
  late String beginTime;
  late String endTime;

  MineWorkCommon({this.beginTime = '', this.endTime = ''});

  Map<String, dynamic> toJson() => {
        'beginTime': beginTime,
        'endTime': endTime,
      };
  void init() {
    DateTime selectedDate = DateTime.now();
    beginTime = '${selectedDate.year}-${selectedDate.month}';
    endTime = '${selectedDate.year}-${selectedDate.month}';
  }

  void setTime(String time) {
    beginTime = time;
    endTime = time;
  }

  void change() {
    notifyListeners();
  }
}

// 我的 火情
class MineFireResponse extends ListResponse<MineFireItem> {
  MineFireResponse.fromJson(super.json) : super.fromJson();

  @override
  MineFireItem generateRecord(Map<String, dynamic> data) =>
      MineFireItem.fromJson(data);
}

class MineFireItem extends ListItemData {
  int id;
  String? deviceName;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String? nickName;
  String? phone;
  String? startTime;
  String? endTime;
  int status;
  int fireType;

  MineFireItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deviceName = json['deviceName'],
        unitName = json['unitName'],
        buildingName = json['buildingName'],
        floorNumber = json['floorNumber'],
        roomNumber = json['roomNumber'],
        nickName = json['nickName'],
        phone = json['phone'],
        startTime = json['startTime'] ?? '',
        endTime = json['endTime'] ?? '',
        status = json['status'],
        fireType = json['fireType'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceName'] = deviceName;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['nickName'] = nickName;
    data['phone'] = phone;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['status'] = status;
    data['fireType'] = fireType;
    return data;
  }
}

class MineFireParams extends Param {
  String? beginTime;
  String? endTime;
  int status = 0;
  int? userId;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'userId': userId,
        'status': status,
      };
}

// 我的 火情统计
class MineFireCount {
  int total;
  int ing;
  int end;
  MineFireCount({this.end = 0, this.ing = 0, this.total = 0});
  MineFireCount.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        ing = json['ing'],
        end = json['end'];
  Map<String, dynamic> toJson() => {
        'total': total,
        'ing': ing,
        'end': end,
      };
}

class MineFireCountParams {
  String? beginTime;
  String? endTime;
  String? unitId;
  int status = 1;
  int? userId;
  Map<String, dynamic> toJson() => {
        'beginTime': beginTime,
        'endTime': endTime,
        'unitId': unitId,
        'status': status,
        'userId': userId
      };
}

// 我的 报警
class MineAlarmResponse extends ListResponse<MineAlarmItem> {
  MineAlarmResponse.fromJson(super.json) : super.fromJson();

  @override
  MineAlarmItem generateRecord(Map<String, dynamic> data) =>
      MineAlarmItem.fromJson(data);
}

class MineAlarmItem extends ListItemData {
  int id;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String deviceName;
  int eventLevel;
  String eventTypeContent;
  int eventCount;
  String? startTime;
  String? confirmTime;
  String? resetTime;
  int confirmResult;
  int status;

  MineAlarmItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deviceName = json['deviceName'],
        unitName = json['unitName'],
        buildingName = json['buildingName'],
        floorNumber = json['floorNumber'],
        roomNumber = json['roomNumber'],
        startTime = json['startTime'],
        confirmTime = json['confirmTime'],
        status = json['status'],
        eventLevel = json['eventLevel'],
        eventTypeContent = json['eventTypeContent'],
        eventCount = json['eventCount'],
        resetTime = json['resetTime'],
        confirmResult = json['confirmResult'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceName'] = deviceName;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['startTime'] = startTime;
    data['confirmTime'] = confirmTime;
    data['status'] = status;
    data['startTime'] = startTime;
    data['eventLevel'] = eventLevel;
    data['eventTypeContent'] = eventTypeContent;
    data['eventCount'] = eventCount;
    data['resetTime'] = resetTime;
    data['confirmResult'] = confirmResult;
    return data;
  }
}

class MineAlarmParams extends Param {
  String? beginTime;
  String? endTime;
  int status = 0;
  int eventLevel = 1;
  int? userId;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'userId': userId,
        'status': status,
      };
}

// 我的 报警统计
class MineAlarmCount {
  int total;
  int ing;
  int end;
  MineAlarmCount({this.end = 0, this.ing = 0, this.total = 0});
  MineAlarmCount.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        ing = json['ing'],
        end = json['end'];
  Map<String, dynamic> toJson() => {
        'total': total,
        'ing': ing,
        'end': end,
      };
}

class MineAlarmCountParams {
  String? beginTime;
  String? endTime;
  String? unitId;
  int status = 1;
  int eventLevel = 1;
  int? userId;

  Map<String, dynamic> toJson() => {
        'beginTime': beginTime,
        'endTime': endTime,
        'unitId': unitId,
        'status': status,
        'userId': userId
      };
}

// 我的 巡检
class MineInspectionResponse extends ListResponse<MineInspectionItem> {
  MineInspectionResponse.fromJson(super.json) : super.fromJson();

  @override
  MineInspectionItem generateRecord(Map<String, dynamic> data) =>
      MineInspectionItem.fromJson(data);
}

class MineInspectionItem extends ListItemData {
  int taskId;
  String name;
  String unitName;
  int type;
  int userId;
  String userName;
  int planType;
  int totalNode;
  int finishTotalNode;
  String? receiveTime;
  int status;
  String? finishedTime;
  int? limitedTime;
  String idCode;

  MineInspectionItem.fromJson(Map<String, dynamic> json)
      : taskId = json["taskId"],
        name = json["name"],
        unitName = json["unitName"],
        type = json["type"],
        userId = json["userId"],
        userName = json["userName"],
        planType = json["planType"],
        totalNode = json["totalNode"],
        finishTotalNode = json["finishTotalNode"],
        receiveTime = json["receiveTime"],
        status = json["status"],
        finishedTime = json["finishedTime"],
        limitedTime = json["limitedTime"],
        idCode = json["idCode"];

  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "name": name,
        "unitName": unitName,
        "type": type,
        "userId": userId,
        "userName": userName,
        "planType": planType,
        "totalNode": totalNode,
        "finishTotalNode": finishTotalNode,
        "receiveTime": receiveTime,
        "status": status,
        "finishedTime": finishedTime,
        "limitedTime": limitedTime,
        "idCode": idCode,
      };
}

class MineInspectionParams extends Param {
  String? beginTime;
  String? endTime;
  int status = 1;
  int? userId;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'userId': userId,
        'status': status,
      };
}

// 我的 巡检统计
class MineInspectionCount {
  int finish;
  int ing;
  int noFinish;
  int total;
  MineInspectionCount(
      {this.finish = 0, this.ing = 0, this.noFinish = 0, this.total = 0});
  MineInspectionCount.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        ing = json['ing'],
        noFinish = json['noFinish'],
        finish = json['finish'];
  Map<String, dynamic> toJson() => {
        'total': total,
        'ing': ing,
        'noFinish': noFinish,
        'finish': finish,
      };
}

class MineInspectionCountParams {
  String? beginTime;
  String? endTime;
  String? unitId;
  int status = 1;
  int? userId;

  Map<String, dynamic> toJson() => {
        'beginTime': beginTime,
        'endTime': endTime,
        'unitId': unitId,
        'status': status,
        'userId': userId
      };
}

// 我的 隐患
class MineTroubleResponse extends ListResponse<MineTroubleItem> {
  MineTroubleResponse.fromJson(super.json) : super.fromJson();

  @override
  MineTroubleItem generateRecord(Map<String, dynamic> data) =>
      MineTroubleItem.fromJson(data);
}

class MineTroubleItem extends ListItemData {
  int id;
  String unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  int levels;
  int type;
  String nickName;
  String? reviewerName;
  String? createTime;
  String? reviewTime;
  String? phone;
  int status;

  MineTroubleItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        unitName = json["unitName"],
        buildingName = json["buildingName"],
        floorNumber = json["floorNumber"],
        roomNumber = json["roomNumber"],
        levels = json["levels"],
        type = json["type"],
        nickName = json["nickName"],
        reviewerName = json["reviewerName"],
        createTime = json["createTime"],
        reviewTime = json["reviewTime"],
        phone = json["phone"],
        status = json["status"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "unitName": unitName,
        "buildingName": buildingName,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "levels": levels,
        "type": type,
        "nickName": nickName,
        "reviewerName": reviewerName,
        "createTime": createTime,
        "reviewTime": reviewTime,
        "phone": phone,
        "status": status,
      };
}

class MineTroubleParams extends Param {
  String? beginTime;
  String? endTime;
  int status = 0;
  int? userId;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'userId': userId,
        'status': status,
      };
}

// 我的 隐患统计
class MineTroubleCount {
  int end;
  int ing;
  int total;
  MineTroubleCount({this.ing = 0, this.end = 0, this.total = 0});
  MineTroubleCount.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        ing = json['ing'],
        end = json['end'];
  Map<String, dynamic> toJson() => {
        'total': total,
        'ing': ing,
        'end': end,
      };
}

class MineTroubleCountParams {
  String? beginTime;
  String? endTime;
  String? unitId;
  int status = 0;
  int? userId;

  Map<String, dynamic> toJson() => {
        'beginTime': beginTime,
        'endTime': endTime,
        'unitId': unitId,
        'status': status,
        'userId': userId
      };
}

// 我的 危险品
class MineDangerResponse extends ListResponse<MineDangerItem> {
  MineDangerResponse.fromJson(super.json) : super.fromJson();

  @override
  MineDangerItem generateRecord(Map<String, dynamic> data) =>
      MineDangerItem.fromJson(data);
}

class MineDangerItem extends ListItemData {
  int id;
  String unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String dangerTypeName;
  String nickName;
  String? reviewerName;
  String? cont;
  String? treatment;
  String? createTime;
  String? reviewTime;
  String? phone;
  int status;

  MineDangerItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        unitName = json["unitName"],
        buildingName = json["buildingName"],
        floorNumber = json["floorNumber"],
        roomNumber = json["roomNumber"],
        dangerTypeName = json["dangerTypeName"],
        nickName = json["nickName"],
        reviewerName = json["reviewerName"],
        cont = json["cont"],
        treatment = json["treatment"],
        createTime = json["createTime"],
        reviewTime = json["reviewTime"],
        phone = json["phone"],
        status = json["status"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "unitName": unitName,
        "buildingName": buildingName,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "dangerTypeName": dangerTypeName,
        "nickName": nickName,
        "reviewerName": reviewerName,
        "cont": cont,
        "treatment": treatment,
        "createTime": createTime,
        "reviewTime": reviewTime,
        "phone": phone,
        "status": status,
      };
}

class MineDangerParams extends Param {
  String? beginTime;
  String? endTime;
  int status = 0;
  int? userId;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'userId': userId,
        'status': status,
      };
}

// 我的 危险品统计
class MineDangerCount {
  int end;
  int ing;
  int total;
  MineDangerCount({this.ing = 0, this.end = 0, this.total = 0});
  MineDangerCount.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        ing = json['ing'],
        end = json['end'];
  Map<String, dynamic> toJson() => {
        'total': total,
        'ing': ing,
        'end': end,
      };
}

class MineDangerCountParams {
  String? beginTime;
  String? endTime;
  String? unitId;
  int status = 0;
  int? userId;

  Map<String, dynamic> toJson() => {
        'beginTime': beginTime,
        'endTime': endTime,
        'unitId': unitId,
        'status': status,
        'userId': userId
      };
}
