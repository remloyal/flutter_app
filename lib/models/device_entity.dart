import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';

class DeviceResponse extends ListResponse<DeviceItem> {
  DeviceResponse.fromJson(super.json) : super.fromJson();

  @override
  DeviceItem generateRecord(Map<String, dynamic> data) =>
      DeviceItem.fromJson(data);
}

class DeviceItem extends ListItemData {
  int id;
  String name;
  String unitName;
  String buildingName;
  dynamic floorNumber;
  dynamic roomNumber;
  int deviceTypeId;
  String deviceTypeName;
  String mac;
  int alarm;
  int fault;
  int online;
  int stop;
  dynamic expire;

  DeviceItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        unitName = json['unitName'] ?? '',
        buildingName = json['buildingName'] ?? '',
        floorNumber = json['floorNumber'] ?? '',
        roomNumber = json['roomNumber'] ?? '',
        deviceTypeId = json['deviceTypeId'],
        deviceTypeName = json['deviceTypeName'] ?? '',
        mac = json['mac'] ?? '',
        alarm = json['alarm'] ?? 0,
        fault = json['fault'] ?? 0,
        online = json['online'] ?? 0,
        stop = json['stop'] ?? 0,
        expire = json['expire'] ?? 0;

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

class DeviceParams extends Param {
  String? keyword = '';
  int? buildId;
  int? floorId;
  int? roomId;
  int? deviceTypeId;
  int? alarm;
  int? online;
  int? stop;
  int? expire;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'keyword': keyword,
        'buildId': buildId,
        'floorId': floorId,
        'roomId': roomId,
        'deviceTypeId': deviceTypeId,
        'alarm': alarm,
        'online': online,
        'stop': stop,
        'expire': expire,
      };

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

class DeviceDetails {
  int id;
  String name;
  String unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  int deviceTypeId;
  String deviceTypeName;
  String mac;
  String? iccId;
  String? imei;
  String? remark;
  String? maintenanceUnit;
  String? maintenanceUser;
  String? maintenancePhone;
  int? lifeMonth;
  int alarm;
  int fault;
  int online;
  int? stop;
  double pointX;
  double pointY;
  double? xRate;
  double? yRate;
  int unitId;
  String? deviceUrl;
  String? deviceSerial;
  String? code;
  String? channelNo;
  int? sd;
  String? network;
  int? manufactorId;
  int? runDay;
  String? startDate;

  DeviceDetails.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        unitName = json["unitName"],
        buildingName = json["buildingName"],
        floorNumber = json["floorNumber"],
        roomNumber = json["roomNumber"],
        deviceTypeId = json["deviceTypeId"],
        deviceTypeName = json["deviceTypeName"],
        mac = json["mac"],
        iccId = json["iccId"],
        imei = json["imei"],
        remark = json["remark"],
        maintenanceUnit = json["maintenanceUnit"],
        maintenanceUser = json["maintenanceUser"],
        maintenancePhone = json["maintenancePhone"],
        lifeMonth = json["lifeMonth"],
        alarm = json["alarm"],
        fault = json["fault"],
        online = json["online"],
        stop = json["stop"] ?? 0,
        pointX = json["pointX"]?.toDouble(),
        pointY = json["pointY"]?.toDouble(),
        xRate = json["xRate"],
        yRate = json["yRate"],
        unitId = json["unitId"],
        deviceUrl = json["deviceUrl"],
        deviceSerial = json["deviceSerial"],
        code = json["code"],
        channelNo = json["channelNo"],
        sd = json["sd"],
        network = json["network"],
        manufactorId = json["manufactorId"],
        runDay = json["runDay"],
        startDate = json["startDate"];
}

// 实时数据
class RealTimeParam {
  String analogName;
  String analogValue;
  String? dataUnit;
  int upTime;

  RealTimeParam.fromJson(Map<dynamic, dynamic> json)
      : analogName = json["analogName"],
        analogValue = json["analogValue"],
        dataUnit = json["dataUnit"],
        upTime = json["upTime"];
}

// 告警提醒
class DeviceEventResponse extends ListResponse<DeviceEventItem> {
  DeviceEventResponse.fromJson(super.json) : super.fromJson();

  @override
  DeviceEventItem generateRecord(Map<String, dynamic> data) =>
      DeviceEventItem.fromJson(data);
}

class DeviceEventItem extends ListItemData {
  // type=1,2
  int? id;
  int? eventLevel;
  String? eventTypeContent;
  int? eventCount;
  String? startTime;
  String? resetTime;
  int? status;

  // type = 5
  int? type;
  String? content;
  int? happenTime;

  DeviceEventItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        eventLevel = json["eventLevel"],
        eventTypeContent = json["eventTypeContent"],
        eventCount = json["eventCount"],
        startTime = json["startTime"],
        resetTime = json["resetTime"],
        status = json["status"],
        type = json["type"],
        content = json["content"],
        happenTime = json["happenTime"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventLevel": eventLevel,
        "eventTypeContent": eventTypeContent,
        "eventCount": eventCount,
        "startTime": startTime,
        "resetTime": resetTime,
        "status": status,
        "type": type,
        "content": content,
        "happenTime": happenTime,
      };
}

class DeviceEventParams extends Param {
  int deviceId;
  int type;

  DeviceEventParams({required this.deviceId, required this.type})
      : super(pageSize: 15);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'deviceId': deviceId,
        'type': type,
      };
}

// 操作记录
class DeviceOperationLogResponse extends ListResponse<OperationLogItem> {
  DeviceOperationLogResponse.fromJson(super.json) : super.fromJson();

  @override
  OperationLogItem generateRecord(Map<String, dynamic> data) =>
      OperationLogItem.fromJson(data);
}

class OperationLogItem extends ListItemData {
  String? userNickname;
  String? operationTypeName;
  String? operationContent;
  int? operationStatus;
  int? createTime;

  OperationLogItem.fromJson(Map<String, dynamic> json)
      : userNickname = json["userNickname"],
        operationTypeName = json["operationTypeName"],
        operationStatus = json["operationStatus"],
        createTime = json["createTime"],
        operationContent = json["operationContent"];

  Map<String, dynamic> toJson() => {
        "userNickname": userNickname,
        "operationTypeName": operationTypeName,
        "operationStatus": operationStatus,
        "createTime": createTime,
        "operationContent": operationContent,
      };
}

class OperationLogParams extends Param {
  int deviceId;

  OperationLogParams({required this.deviceId}) : super();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'deviceId': deviceId,
      };
}

class DeviceType {
  int type;
  String name;

  DeviceType.fromJson(Map<String, dynamic> json)
      : type = json["type"],
        name = json["name"];

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
  };
}

class FindParam {
  String source;
  String keyword;

  FindParam({required this.source, required this.keyword});
}