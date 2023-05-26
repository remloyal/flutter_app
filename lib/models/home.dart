import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fire_control_app/models/unit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Params {
  dynamic unitId;
  int type = 1;
  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'type': type,
      };
}

class DeviceParams {
  dynamic unitId;
  Map<String, dynamic> toJson() => {
        'unitId': unitId,
      };
}

class AlarmStats {
  int fire;
  int alarm;
  int fault;
  int trouble;
  int danger;
  int risk;

  AlarmStats({
    required this.fire,
    required this.alarm,
    required this.fault,
    required this.trouble,
    required this.danger,
    required this.risk,
  });

  AlarmStats.fromJson(Map<String, dynamic> json)
      : fire = json['fire'],
        alarm = json['alarm'],
        fault = json['fault'],
        trouble = json['trouble'],
        danger = json['danger'],
        risk = json['risk'];

  Map<String, dynamic> toJson() => {
        'fire': fire,
        'alarm': alarm,
        'fault': fault,
        'trouble': trouble,
        'danger': danger,
        'risk': risk
      };
}

class InspectStats {
  // 完成率
  dynamic completionRate;
  // 额定任务
  dynamic ratedTasks;
  // 完成任务
  dynamic completionTasks;
  // 巡检路线
  dynamic inspectRoutes;
  // 巡检人数
  dynamic inspectNumber;

  InspectStats({
    required this.completionRate,
    required this.ratedTasks,
    required this.completionTasks,
    required this.inspectRoutes,
    required this.inspectNumber,
  });

  InspectStats.fromJson(Map<String, dynamic> json)
      : completionRate = json['completionRate'] as String,
        ratedTasks = json['ratedTasks'] ?? 0,
        completionTasks = json['completionTasks'] ?? 0,
        inspectRoutes = json['inspectRoutes'] ?? 0,
        inspectNumber = json['inspectNumber'] ?? 0;

  Map<String, dynamic> toJson() => {
        'completionRate': completionRate,
        'ratedTasks': ratedTasks,
        'completionTasks': completionTasks,
        'inspectRoutes': inspectRoutes,
        'inspectNumber': inspectNumber
      };
}

class DeviceStats {
  // 设备总数
  int total;
  // 在线率
  String onlineRate;
  // 在线
  int online;
  // 离线
  int offline;
  // 异常率
  String abnormalRate;
  // 正常
  int normal;
  // 异常
  int abnormal;

  DeviceStats({
    required this.total,
    required this.onlineRate,
    required this.online,
    required this.offline,
    required this.abnormalRate,
    required this.normal,
    required this.abnormal,
  });

  DeviceStats.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        onlineRate = json['onlineRate'],
        online = json['online'],
        offline = json['offline'],
        abnormalRate = json['abnormalRate'],
        normal = json['normal'],
        abnormal = json['abnormal'];

  Map<String, dynamic> toJson() => {
        'count': total,
        'onlineRate': onlineRate,
        'online': online,
        'offline': offline,
        'abnormalRate': abnormalRate,
        'normal': normal,
        'alarm': abnormal,
      };
}

// 上报资源管理
class FileData with ChangeNotifier {
  // 用於存儲文件 ID 的列表
  List<dynamic> fileIds = [];
  // 文件類型，火情為 1，隱患為 2，危險品為 10
  String type = '1';
  // 用於存儲 FileTerm 對象的列表
  List<FileTerm> converts = [];
  bool state = true;
  FileData();
  // 將 FileData 對象轉換為 JSON 格式
  Map<String, dynamic> toJson() =>
      {'fileIds': fileIds, 'type': type, 'fileTerms': converts};
  // 通知監聽器有更改發生
  void change() {
    notifyListeners();
  }

  // 將 XFile 對象轉換為 FileTerm 對象並添加到列表中，並返回 FileTerm 對象與索引
  Future<List<dynamic>> addFile(XFile file) async {
    File papers = File(file.path);
    Uint8List bytes = await file.readAsBytes();
    var data = await MultipartFile.fromFile(
      file.path,
    );
    FileTerm item =
        FileTerm(type: 'image', data: data, uint8List: bytes, file: papers);
    converts.add(item);
    return [item, converts.indexOf(item)];
  }

  // 將多個 XFile 對象添加到列表中，並返回 FileTerm 對象與索引
  Future<List<dynamic>> addAllFile(List<XFile> files) async {
    List data = [];
    for (var i = 0; i < files.length; i++) {
      var todo = await addFile(files[i]);
      data.add(todo);
    }
    return data;
  }

  // 將 XFile 對象轉換為 FileTerm 對象並添加到列表中，並返回 FileTerm 對象與索引
  Future<List<dynamic>> addVideoFile(XFile file) async {
    File bytes = File(file.path);
    final videoImage = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    var data = await MultipartFile.fromFile(file.path);
    FileTerm item = FileTerm(
        type: 'video', data: data, videoImage: videoImage, file: bytes);
    converts.add(item);
    return [item, converts.indexOf(item)];
  }

  // 清空 fileIds 列表
  void clean() {
    fileIds = [];
  }
}

class FileTerm {
  String type;
  int? id;
  Uint8List? uint8List;
  Uint8List? videoImage;
  MultipartFile data;
  double? progress;
  File? file;
  FileTerm(
      {required this.type,
      this.id,
      this.uint8List,
      this.videoImage,
      this.file,
      required this.data});
  // 將 FileTerm 對象轉換為 JSON 格式
  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'uint8List': uint8List,
        'videoImage': videoImage,
        'data': data,
        'progress': progress,
        'file': file
      };
}

// 上报信息参数
class UpdateInfo {
  Unit? unit;
  Map? building;
  Map? floor;
  Map? room;

  String textName = '';

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'building': building,
        'floor': floor,
        'room': room,
        'textName': textName
      };

  initText() {
    if (building != null) {
      textName = building!['name'];
    }
    if (floor != null) {
      textName = '$textName - ${floor!['name']}';
    }
    if (room != null) {
      textName = '$textName - ${room!['name']}';
    }
  }
}

// 火情上报参数
class FileUpdateParam {
  int? unitId;
  int? buildingId;
  int? floorId;
  int? roomId;
  double? pointX;
  double? pointY;
  double? xRate;
  double? yRate;
  String? remark;
  int? fileNumber;
  String? attachmentIds;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'buildingId': buildingId,
        'floorId': floorId,
        'roomId': roomId,
        'pointX': pointX,
        'pointY': pointY,
        'xRate': xRate,
        'yRate': yRate,
        'remark': remark,
        'fileNumber': fileNumber,
        'attachmentIds': attachmentIds,
      };
  check() {
    String message = '';
    if (unitId == null) {
      return message = '请选择单位';
    }
    if (remark == null) {
      return message = '请填写火情描述';
    }
    return true;
  }
}

// 隐患上报参数
class TroubleUpdateParam {
  int? unitId;
  int? buildingId;
  int? floorId;
  int? roomId;

  double? pointX;
  double? pointY;
  double? xRate;
  double? yRate;

  int? levels = 3;
  int? type = 1;
  String? cont;
  int? fileNumber;
  String? attachmentIds;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'buildingId': buildingId,
        'floorId': floorId,
        'roomId': roomId,
        'pointX': pointX,
        'pointY': pointY,
        'xRate': xRate,
        'yRate': yRate,
        'levels': levels,
        'type': type,
        'cont': cont,
        'fileNumber': fileNumber,
        'attachmentIds': attachmentIds,
      };
  check() {
    String message = '';
    if (unitId == null) {
      return message = '请选择单位';
    }
    if (cont == null) {
      return message = '请填写隐患描述';
    }
    return true;
  }
}

// 危险品上报参数
class DangerUpdateParam {
  int? unitId;
  int? buildingId;
  int? floorId;
  int? roomId;

  double? pointX;
  double? pointY;
  double? xRate;
  double? yRate;

  int? type;
  String? name;
  String? cont;
  int? fileNumber;
  String? attachmentIds;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'buildingId': buildingId,
        'floorId': floorId,
        'roomId': roomId,
        'pointX': pointX,
        'pointY': pointY,
        'xRate': xRate,
        'yRate': yRate,
        'type': type,
        'name': name,
        'cont': cont,
        'fileNumber': fileNumber,
        'attachmentIds': attachmentIds,
      };
  check() {
    String message = '';
    if (unitId == null) {
      return message = '请选择单位';
    }
    if (type == null) {
      return message = '请选择危险品类型';
    }
    if (name == null) {
      return message = '请填写危险品名称';
    }
    if (cont == null) {
      return message = '请填写危险品描述';
    }
    return true;
  }
}

class DangerType {
  int id;
  String name;

  DangerType({
    this.id = 0,
    this.name = '',
  });

  factory DangerType.fromJson(Map<String, dynamic> json) => DangerType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
