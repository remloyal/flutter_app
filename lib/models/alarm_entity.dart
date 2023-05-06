import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';
import 'package:flutter/material.dart';

class FireResponse extends ListResponse<FireItem> {
  FireResponse.fromJson(super.json) : super.fromJson();

  @override
  FireItem generateRecord(Map<String, dynamic> data) => FireItem.fromJson(data);
}

class FireItem extends ListItemData {
  int id;
  String deviceName;
  String unitName;
  String buildingName;
  String floorNumber;
  String roomNumber;
  String nickName;
  String? phone;
  String startTime;
  String endTime;
  int status;
  int fireType;

  FireItem.fromJson(Map<String, dynamic> json)
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

class FireParams extends Param {
  dynamic beginTime;
  dynamic endTime;
  int sourceType = 0;
  int status = 0;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'sourceType': sourceType,
        'status': status,
      };
}

class AlarmParams extends Param {
  dynamic beginTime;
  dynamic endTime;
  dynamic keyword;
  int eventLevel = 1;
  dynamic deviceTypeId;
  int status = 0;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'keyword': keyword,
        'eventLevel': eventLevel,
        'deviceTypeId': deviceTypeId,
        'status': status,
      };
}

class AlarmResponse extends ListResponse<AlarmItem> {
  AlarmResponse.fromJson(super.json) : super.fromJson();

  @override
  AlarmItem generateRecord(Map<String, dynamic> data) =>
      AlarmItem.fromJson(data);
}

class AlarmItem extends ListItemData {
  int id;
  String unitName;
  String buildingName;
  String floorNumber;
  String? roomNumber;
  String deviceName;
  int eventLevel;
  String eventTypeContent;
  int eventCount;
  String startTime;
  String? confirmTime;
  String? resetTime;
  int? confirmResult;
  int status;

  AlarmItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unitName = json['unitName'],
        buildingName = json['buildingName'],
        floorNumber = json['floorNumber'],
        roomNumber = json['roomNumber'],
        deviceName = json['deviceName'],
        eventLevel = json['eventLevel'],
        eventTypeContent = json['eventTypeContent'],
        eventCount = json['eventCount'],
        startTime = json['startTime'],
        confirmTime = json['confirmTime'],
        resetTime = json['resetTime'],
        confirmResult = json['confirmResult'],
        status = json['status'];

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

// 隐患
class TroubleResponse extends ListResponse<TroubleItem> {
  TroubleResponse.fromJson(super.json) : super.fromJson();

  @override
  TroubleItem generateRecord(Map<String, dynamic> data) =>
      TroubleItem.fromJson(data);
}

class TroubleItem extends ListItemData {
  int id;
  String unitName;
  String buildingName;
  String floorNumber;
  String roomNumber;
  int levels;
  int type;
  String? nickName;
  String? phone;
  String createTime;
  dynamic reviewTime;
  int? status;

  TroubleItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unitName = json['unitName'],
        buildingName = json['buildingName'],
        floorNumber = json['floorNumber'],
        roomNumber = json['roomNumber'],
        levels = json['levels'],
        type = json['type'],
        nickName = json['nickName'],
        phone = json['phone'],
        createTime = json['createTime'],
        reviewTime = json['reviewTime'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['levels'] = levels;
    data['type'] = type;
    data['nickName'] = nickName;
    data['phone'] = phone;
    data['createTime'] = createTime;
    data['reviewTime'] = reviewTime;
    data['status'] = status;
    return data;
  }
}

class TroubleParams extends Param {
  dynamic beginTime;
  dynamic endTime;
  dynamic type;
  dynamic levels;
  int status = 0;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'type': type,
        'levels': levels,
        'status': status,
      };
}

// 危险品
class DangerResponse extends ListResponse<DangerItem> {
  DangerResponse.fromJson(super.json) : super.fromJson();

  @override
  DangerItem generateRecord(Map<String, dynamic> data) =>
      DangerItem.fromJson(data);
}

class DangerItem extends ListItemData {
  int id;
  String unitName;
  String buildingName;
  String floorNumber;
  String roomNumber;
  String dangerTypeName;
  String? nickName;
  String? phone;
  String cont;
  String treatment;
  String createTime;
  dynamic reviewTime;
  int status;

  DangerItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unitName = json['unitName'],
        buildingName = json['buildingName'],
        floorNumber = json['floorNumber'],
        roomNumber = json['roomNumber'],
        dangerTypeName = json['dangerTypeName'],
        nickName = json['nickName'],
        phone = json['phone'],
        cont = json['cont'],
        treatment = json['treatment'],
        createTime = json['createTime'],
        reviewTime = json['reviewTime'],
        status = json['status'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unitName'] = unitName;
    data['buildingName'] = buildingName;
    data['floorNumber'] = floorNumber;
    data['roomNumber'] = roomNumber;
    data['dangerTypeName'] = dangerTypeName;
    data['nickName'] = nickName;
    data['phone'] = phone;
    data['cont'] = cont;
    data['treatment'] = treatment;
    data['createTime'] = createTime;
    data['reviewTime'] = reviewTime;
    data['status'] = status;
    return data;
  }
}

class DangerParams extends Param {
  dynamic beginTime;
  dynamic endTime;
  dynamic type;
  int status = 0;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'type': type,
        'status': status,
      };
}

// 风险
class RiskResponse extends ListResponse<RiskItem> {
  RiskResponse.fromJson(super.json) : super.fromJson();

  @override
  RiskItem generateRecord(Map<String, dynamic> data) => RiskItem.fromJson(data);
}

class RiskItem extends ListItemData {
  int? id;
  String unitName;
  String? warnSource;
  int warnType;
  String? warnContent;
  double? warnValue;
  dynamic standardValue;
  dynamic relieveWarnValue;
  String startTime;
  dynamic endTime;
  int? warnStatus;

  RiskItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unitName = json['unitName'],
        warnSource = json['warnSource'],
        warnType = json['warnType'],
        warnContent = json['warnContent'],
        warnValue = json['warnValue'],
        standardValue = json['standardValue'],
        relieveWarnValue = json['relieveWarnValue'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        warnStatus = json['warnStatus'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unitName'] = unitName;
    data['warnSource'] = warnSource;
    data['warnType'] = warnType;
    data['warnContent'] = warnContent;
    data['warnValue'] = warnValue;
    data['standardValue'] = standardValue;
    data['relieveWarnValue'] = relieveWarnValue;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['warnStatus'] = warnStatus;
    return data;
  }
}

class RiskParams extends Param {
  dynamic beginTime;
  dynamic endTime;
  dynamic warnType;
  int warnStatus = 1;

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'warnType': warnType,
        'warnStatus': warnStatus,
      };
}

// 提醒
class RemindResponse extends ListResponse<RemindItem> {
  RemindResponse.fromJson(super.json) : super.fromJson();

  @override
  RemindItem generateRecord(Map<String, dynamic> data) =>
      RemindItem.fromJson(data);
}

class RemindItem extends ListItemData {
  String unitName;
  int type;
  String source;
  String content;
  int happenTime;

  RemindItem.fromJson(Map<String, dynamic> json)
      : unitName = json['unitName'],
        type = json['type'],
        source = json['source'],
        content = json['content'],
        happenTime = json['happenTime'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unitName'] = unitName;
    data['type'] = type;
    data['source'] = source;
    data['content'] = content;
    data['happenTime'] = happenTime;
    return data;
  }
}

class RemindParams extends Param {
  dynamic beginTime;
  dynamic endTime;
  dynamic type;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'beginTime': beginTime,
        'endTime': endTime,
        'type': type
      };
}

class FireDetail {
  List<Attachment>? attachments;
  String buildingName;
  String cancelNickName;
  String? cancelPhone;
  String cancelRemark;
  String confirmNickName;
  String? confirmPhone;
  String confirmReason;
  String confirmTime;
  int? cycle;
  int deviceId;
  String deviceMac;
  String deviceName;
  String deviceTypeName;
  String? endTime;
  String? eventTypeContent;
  int fireType;
  String floorNumber;
  int id;
  List<LbsInfo>? lbsList;
  String nickName;
  String? phone;
  double pointX;
  double pointY;
  String remark;
  String roomNumber;
  String startTime;
  int status;
  int unitId;
  String unitName;
  List<CameraInfo>? videos;
  double xRate;
  double yRate;

  FireDetail.fromJson(Map<String, dynamic> json)
      : attachments = json['attachments']
            ?.map((v) => Attachment.fromJson(v))
            .toList()
            .cast<Attachment>(),
        buildingName = json['buildingName'],
        cancelNickName = json['cancelNickName'],
        cancelPhone = json['cancelPhone'],
        cancelRemark = json['cancelRemark'],
        confirmNickName = json['confirmNickName'],
        confirmPhone = json['confirmPhone'],
        confirmReason = json['confirmReason'],
        confirmTime = json['confirmTime'],
        cycle = json['cycle'],
        deviceId = json['deviceId'],
        deviceMac = json['deviceMac'],
        deviceName = json['deviceName'],
        deviceTypeName = json['deviceTypeName'],
        endTime = json['endTime'],
        eventTypeContent = json['eventTypeContent'],
        fireType = json['fireType'],
        floorNumber = json['floorNumber'],
        id = json['id'],
        lbsList = json['lbsList']
            ?.map((v) => LbsInfo.fromJson(v))
            .toList()
            .cast<LbsInfo>(),
        nickName = json['nickName'],
        phone = json['phone'],
        pointX = json['pointX'],
        pointY = json['pointY'],
        remark = json['remark'],
        roomNumber = json['roomNumber'],
        startTime = json['startTime'],
        status = json['status'],
        unitId = json['unitId'],
        unitName = json['unitName'],
        videos = json['videos']
            ?.map((v) => CameraInfo.fromJson(v))
            .toList()
            .cast<CameraInfo>(),
        xRate = json['xRate'],
        yRate = json['yRate'];
}

class Attachment {
  int? attachmentType;
  String attachmentUrl;
  int targetAction;

  Attachment.fromJson(Map<String, dynamic> json)
      : attachmentType = json['attachmentType'],
        attachmentUrl = json['attachmentUrl'],
        targetAction = json['targetAction'];
}

class CameraInfo {
  String buildingName;
  String? channelNo;
  String? code;
  String? deviceSerial;
  String deviceUrl;
  String? floorNumber;
  int id;
  int? manufactorId;
  String name;
  String? network;
  String? roomNumber;
  int? sd;
  String unitName;

  CameraInfo.fromJson(Map<String, dynamic> json)
      : buildingName = json['buildingName'],
        channelNo = json['channelNo'],
        code = json['code'],
        deviceSerial = json['deviceSerial'],
        deviceUrl = json['deviceUrl'],
        floorNumber = json['floorNumber'],
        id = json['id'],
        manufactorId = json['manufactorId'],
        name = json['name'],
        network = json['network'],
        roomNumber = json['roomNumber'],
        sd = json['sd'],
        unitName = json['unitName'];
}

class LbsInfo {
  String? address;
  int? buildingId;
  String crTime;
  int departmentId;
  LbsExtension extensions;
  int? groupCount;
  String id;
  LbsLoc loc;
  int objId;
  String title;
  int type;
  String? upTime;

  LbsInfo.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        buildingId = json['buildingId'],
        crTime = json['crTime'],
        departmentId = json['departmentId'],
        extensions = LbsExtension.fromJson(json['extensions']),
        groupCount = json['groupCount'],
        id = json['id'],
        loc = LbsLoc.fromJson(json['loc']),
        objId = json['objId'],
        title = json['title'],
        type = json['type'],
        upTime = json['upTime'];
}

class LbsExtension {
  int? deviceType;
  String? deviceTypeName;

  String? humanRole;
  String? phone;
  String? userAvatar;

  LbsExtension.fromJson(Map<dynamic, dynamic> json)
      : deviceType = json['DEVICE_TYPE'],
        deviceTypeName = json['DEVICE_TYPE_NAME'],
        humanRole = json['HUMAN_ROLE'],
        phone = json['PHONE'],
        userAvatar = json['USER_AVATAR'];
}

class LbsLoc {
  String type;
  List<double> coordinates;

  LbsLoc.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        coordinates = json['coordinates'].cast<double>();
}

class AlarmDetail {
  List<Attachment>? attachments;
  String buildingName;
  String confirmNickName;
  String? confirmPhone;
  String confirmReason;
  int confirmResult;
  String? confirmTime;
  int deviceId;
  String deviceMac;
  String deviceName;
  String deviceTypeName;
  List<dynamic>? devices;
  int eventCount;
  int eventLevel;
  String eventTypeContent;
  String floorNumber;
  int id;
  double pointX;
  double pointY;
  String? resetTime;
  String? roomNumber;
  String startTime;
  int? status;
  String? svgUrl;
  int unitId;
  String unitName;
  List<CameraInfo>? videos;
  double xRate;
  double yRate;

  AlarmDetail.fromJson(Map<String, dynamic> json)
      : attachments = json['attachments']
            ?.map((v) => Attachment.fromJson(v))
            .toList()
            .cast<Attachment>(),
        buildingName = json['buildingName'],
        confirmNickName = json['confirmNickName'],
        confirmPhone = json['confirmPhone'],
        confirmReason = json['confirmReason'],
        confirmResult = json['confirmResult'],
        confirmTime = json['confirmTime'],
        deviceId = json['deviceId'],
        deviceMac = json['deviceMac'],
        deviceName = json['deviceName'],
        deviceTypeName = json['deviceTypeName'],
        devices = json['devices'],
        eventCount = json['eventCount'],
        eventLevel = json['eventLevel'],
        eventTypeContent = json['eventTypeContent'],
        floorNumber = json['floorNumber'],
        id = json['id'],
        pointX = json['pointX'],
        pointY = json['pointY'],
        resetTime = json['resetTime'],
        roomNumber = json['roomNumber'],
        startTime = json['startTime'],
        status = json['status'],
        svgUrl = json['svgUrl'],
        unitId = json['unitId'],
        unitName = json['unitName'],
        videos = json['videos']
            ?.map((v) => CameraInfo.fromJson(v))
            .toList()
            .cast<CameraInfo>(),
        xRate = json['xRate'],
        yRate = json['yRate'];
}

class TroubleDetail {
  List<Attachment>? attachments;
  String buildingName;
  String cont;
  String createTime;
  String floorNumber;
  int id;
  int levels;
  String nickName;
  String? phone;
  double pointX;
  double pointY;
  String? reviewTime;
  String reviewerName;
  String? reviewerPhone;
  String roomNumber;
  int status;
  String? svgUrl;
  String treatment;
  int type;
  int unitId;
  String unitName;
  double xRate;
  double yRate;

  TroubleDetail.fromJson(Map<String, dynamic> json)
      : attachments = json['attachments']
            ?.map((v) => Attachment.fromJson(v))
            .toList()
            .cast<Attachment>(),
        buildingName = json['buildingName'],
        cont = json['cont'],
        createTime = json['createTime'],
        floorNumber = json['floorNumber'],
        id = json['id'],
        levels = json['levels'],
        nickName = json['nickName'],
        phone = json['phone'],
        pointX = json['pointX'],
        pointY = json['pointY'],
        reviewTime = json['reviewTime'],
        reviewerName = json['reviewerName'],
        reviewerPhone = json['reviewerPhone'],
        roomNumber = json['roomNumber'],
        status = json['status'],
        svgUrl = json['svgUrl'],
        treatment = json['treatment'],
        type = json['type'],
        unitId = json['unitId'],
        unitName = json['unitName'],
        xRate = json['xRate'],
        yRate = json['yRate'];
}

class DangerDetail {
  List<Attachment>? attachments;
  String buildingName;
  String cont;
  String createTime;
  String dangerName;
  String dangerTypeName;
  String floorNumber;
  int id;
  String nickName;
  String? phone;
  double pointX;
  double pointY;
  String? reviewTime;
  String reviewerName;
  String? reviewerPhone;
  String roomNumber;
  int status;
  String? svgUrl;
  String treatment;
  int unitId;
  String unitName;
  double xRate;
  double yRate;

  DangerDetail.fromJson(Map<String, dynamic> json)
      : attachments = json['attachments']
            ?.map((v) => Attachment.fromJson(v))
            .toList()
            .cast<Attachment>(),
        buildingName = json['buildingName'],
        cont = json['cont'],
        createTime = json['createTime'],
        dangerName = json['dangerName'],
        dangerTypeName = json['dangerTypeName'],
        floorNumber = json['floorNumber'],
        id = json['id'],
        nickName = json['nickName'],
        phone = json['phone'],
        pointX = json['pointX'],
        pointY = json['pointY'],
        reviewTime = json['reviewTime'],
        reviewerName = json['reviewerName'],
        reviewerPhone = json['reviewerPhone'],
        roomNumber = json['roomNumber'],
        status = json['status'],
        svgUrl = json['svgUrl'],
        treatment = json['treatment'],
        unitId = json['unitId'],
        unitName = json['unitName'],
        xRate = json['xRate'],
        yRate = json['yRate'];
}
