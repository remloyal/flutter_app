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

  DeviceItem.fromJson(Map<String, dynamic> json):
    id = json['id'],
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
