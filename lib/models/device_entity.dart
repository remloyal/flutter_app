import 'package:flutter/material.dart';

class DeviceList {
  late int currentPage;
  late int totalPage;
  late int totalRow;
  late int pageSize;
  late String orderByClause;
  late bool needCount;
  late List<DeviceItem>? result;
  late int fromRow;

  DeviceList(
      {this.currentPage = 1,
      this.totalPage = 0,
      this.totalRow = 0,
      this.pageSize = 0,
      this.orderByClause = '',
      this.needCount = false,
      this.result,
      this.fromRow = 0});

  DeviceList.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <DeviceItem>[];
      json['result'].forEach((v) {
        result!.add(DeviceItem.fromJson(v));
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

class DeviceItem {
  late int id;
  late String name;
  late String unitName;
  late String buildingName;
  late dynamic floorNumber;
  late dynamic roomNumber;
  late int deviceTypeId;
  late String deviceTypeName;
  late String mac;
  late int alarm;
  late int fault;
  late int online;
  late int stop;
  late dynamic expire;

  DeviceItem(
      {required int id,
      required String name,
      required String unitName,
      required String buildingName,
      required String floorNumber,
      required dynamic roomNumber,
      required int deviceTypeId,
      required String deviceTypeName,
      required String mac,
      required int alarm,
      required int fault,
      required int online,
      required int stop,
      required dynamic expire});

  DeviceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    unitName = json['unitName'] ?? '';
    buildingName = json['buildingName'] ?? '';
    floorNumber = json['floorNumber'] ?? '';
    roomNumber = json['roomNumber'] ?? '';
    deviceTypeId = json['deviceTypeId'];
    deviceTypeName = json['deviceTypeName'] ?? '';
    mac = json['mac'] ?? '';
    alarm = json['alarm'] ?? 0;
    fault = json['fault'] ?? 0;
    online = json['online'] ?? 0;
    stop = json['stop'] ?? 0;
    expire = json['expire'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['deviceTypeId'] = deviceTypeId;
    data['deviceTypeName'] = deviceTypeName;
    data['mac'] = mac;
    data['alarm'] = alarm;
    data['fault'] = fault;
    data['online'] = online;
    data['stop'] = stop;
    data['expire'] = expire;
    return data;
  }
}

class DeviceParams extends ChangeNotifier {
  dynamic unitId;
  String? keyword = '';
  int currentPage = 1;
  int pageSize = 10;
  int? buildId;
  int? floorId;
  int? roomId;
  int? deviceTypeId;
  int? alarm;
  int? online;
  int? stop;
  int? expire;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'keyword': keyword,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'buildId': buildId,
        'floorId': floorId,
        'roomId': roomId,
        'deviceTypeId': deviceTypeId,
        'alarm': alarm,
        'online': online,
        'stop': stop,
        'expire': expire,
      };

  void change() {
    notifyListeners();
  }

  // 重置
  void initial() {
    unitId = null;
    keyword = '';
    currentPage = 1;
    pageSize = 10;
    buildId = null;
    floorId = null;
    roomId = null;
    deviceTypeId = null;
    alarm = null;
    online = null;
    stop = null;
    expire = null;
  }
}
