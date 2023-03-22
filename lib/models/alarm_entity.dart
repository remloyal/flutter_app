import 'package:flutter/material.dart';

class FireCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<FireResult>? result;
  int? fromRow;

  FireCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<FireResult>? result,
      int? fromRow});

  FireCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <FireResult>[];
      json['result'].forEach((v) {
        result!.add(FireResult.fromJson(v));
      });
    }
    fromRow = json['fromRow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPage'] = totalPage;
    data['totalRow'] = totalRow;
    data['pageSize'] = pageSize;
    data['orderByClause'] = orderByClause;
    data['needCount'] = needCount;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['fromRow'] = fromRow;
    return data;
  }
}

class FireResult {
  int? id;
  String? deviceName;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String? nickName;
  dynamic phone;
  dynamic startTime;
  dynamic endTime;
  int? status;
  int? fireType;

  FireResult(
      {int? id,
      String? deviceName,
      String? unitName,
      String? buildingName,
      String? floorNumber,
      String? roomNumber,
      String? nickName,
      dynamic phone,
      dynamic startTime,
      dynamic endTime,
      int? status,
      int? fireType});

  FireResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceName = json['deviceName'];
    unitName = json['unitName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    roomNumber = json['roomNumber'];
    nickName = json['nickName'];
    phone = json['phone'];
    startTime = json['startTime'] ?? '';
    endTime = json['endTime'] ?? '';
    status = json['status'];
    fireType = json['fireType'];
  }

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

class FireParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  int sourceType = 0;
  int status = 0;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'sourceType': sourceType,
        'status': status,
      };
  void change() {
    notifyListeners();
  }
}

class AlarmParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  dynamic keyword;
  int eventLevel = 1;
  dynamic deviceTypeId;
  int status = 0;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'keyword': keyword,
        'eventLevel': eventLevel,
        'deviceTypeId': deviceTypeId,
        'status': status,
      };
  void change() {
    notifyListeners();
  }
}

class AlarmCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<AlarmResult>? result;
  int? fromRow;

  AlarmCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<AlarmResult>? result,
      int? fromRow});

  AlarmCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <AlarmResult>[];
      json['result'].forEach((v) {
        result!.add(AlarmResult.fromJson(v));
      });
    }
    fromRow = json['fromRow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = currentPage;
    data['totalPage'] = totalPage;
    data['totalRow'] = totalRow;
    data['pageSize'] = pageSize;
    data['orderByClause'] = orderByClause;
    data['needCount'] = needCount;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['fromRow'] = fromRow;
    return data;
  }
}

class AlarmResult {
  int? id;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String? deviceName;
  int? eventLevel;
  String? eventTypeContent;
  int? eventCount;
  String? startTime;
  String? confirmTime;
  dynamic resetTime;
  int? confirmResult;
  int? status;

  AlarmResult(
      {int? id,
      String? unitName,
      String? buildingName,
      String? floorNumber,
      String? roomNumber,
      String? deviceName,
      int? eventLevel,
      String? eventTypeContent,
      int? eventCount,
      String? startTime,
      String? confirmTime,
      dynamic resetTime,
      int? confirmResult,
      int? status});

  AlarmResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unitName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    roomNumber = json['roomNumber'];
    deviceName = json['deviceName'];
    eventLevel = json['eventLevel'];
    eventTypeContent = json['eventTypeContent'];
    eventCount = json['eventCount'];
    startTime = json['startTime'];
    confirmTime = json['confirmTime'];
    resetTime = json['resetTime'];
    confirmResult = json['confirmResult'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['deviceName'] = deviceName;
    data['eventLevel'] = eventLevel;
    data['eventTypeContent'] = eventTypeContent;
    data['eventCount'] = eventCount;
    data['startTime'] = startTime;
    data['confirmTime'] = confirmTime;
    data['resetTime'] = resetTime;
    data['confirmResult'] = confirmResult;
    data['status'] = status;
    return data;
  }
}

class FaultCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<FaultResult>? result;
  int? fromRow;

  FaultCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<FaultResult>? result,
      int? fromRow});

  FaultCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <FaultResult>[];
      json['result'].forEach((v) {
        result!.add(FaultResult.fromJson(v));
      });
    }
    fromRow = json['fromRow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPage'] = totalPage;
    data['totalRow'] = totalRow;
    data['pageSize'] = pageSize;
    data['orderByClause'] = orderByClause;
    data['needCount'] = needCount;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['fromRow'] = fromRow;
    return data;
  }
}

class FaultResult {
  int? id;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String? deviceName;
  int? eventLevel;
  String? eventTypeContent;
  int? eventCount;
  String? startTime;
  dynamic confirmTime;
  dynamic resetTime;
  int? confirmResult;
  int? status;

  FaultResult(
      {int? id,
      String? unitName,
      String? buildingName,
      String? floorNumber,
      String? roomNumber,
      String? deviceName,
      int? eventLevel,
      String? eventTypeContent,
      int? eventCount,
      String? startTime,
      dynamic confirmTime,
      dynamic resetTime,
      int? confirmResult,
      int? status});

  FaultResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unitName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    roomNumber = json['roomNumber'];
    deviceName = json['deviceName'];
    eventLevel = json['eventLevel'];
    eventTypeContent = json['eventTypeContent'];
    eventCount = json['eventCount'];
    startTime = json['startTime'];
    confirmTime = json['confirmTime'];
    resetTime = json['resetTime'];
    confirmResult = json['confirmResult'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['deviceName'] = deviceName;
    data['eventLevel'] = eventLevel;
    data['eventTypeContent'] = eventTypeContent;
    data['eventCount'] = eventCount;
    data['startTime'] = startTime;
    data['confirmTime'] = confirmTime;
    data['resetTime'] = resetTime;
    data['confirmResult'] = confirmResult;
    data['status'] = status;
    return data;
  }
}

class FaultParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  dynamic keyword;
  int eventLevel = 0;
  dynamic deviceTypeId;
  int status = 0;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'keyword': keyword,
        'eventLevel': eventLevel,
        'deviceTypeId': deviceTypeId,
        'status': status,
      };
  void change() {
    notifyListeners();
  }
}
