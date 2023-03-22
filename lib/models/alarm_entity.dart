import 'package:flutter/material.dart';

class FireCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<Result>? result;
  int? fromRow;

  FireCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<Result>? result,
      int? fromRow});

  FireCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
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

class Result {
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

  Result(
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

  Result.fromJson(Map<String, dynamic> json) {
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
