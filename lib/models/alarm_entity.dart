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

// 隐患
class TroubleCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<TroubleResult>? result;
  int? fromRow;

  TroubleCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<TroubleResult>? result,
      int? fromRow});

  TroubleCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <TroubleResult>[];
      json['result'].forEach((v) {
        result!.add(TroubleResult.fromJson(v));
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

class TroubleResult {
  int? id;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  int? levels;
  int? type;
  String? nickName;
  String? phone;
  String? createTime;
  dynamic reviewTime;
  int? status;

  TroubleResult(
      {int? id,
      String? unitName,
      String? buildingName,
      String? floorNumber,
      String? roomNumber,
      int? levels,
      int? type,
      String? nickName,
      String? phone,
      String? createTime,
      dynamic reviewTime,
      int? status});

  TroubleResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unitName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    roomNumber = json['roomNumber'];
    levels = json['levels'];
    type = json['type'];
    nickName = json['nickName'];
    phone = json['phone'];
    createTime = json['createTime'];
    reviewTime = json['reviewTime'];
    status = json['status'];
  }

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

class TroubleParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  dynamic type;
  dynamic levels;
  int status = 0;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'type': type,
        'levels': levels,
        'status': status,
      };
  void change() {
    notifyListeners();
  }
}

// 危险品
class DangerCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<DangerResult>? result;
  int? fromRow;

  DangerCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<DangerResult>? result,
      int? fromRow});

  DangerCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <DangerResult>[];
      json['result'].forEach((v) {
        result!.add(DangerResult.fromJson(v));
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

class DangerResult {
  int? id;
  String? unitName;
  String? buildingName;
  String? floorNumber;
  String? roomNumber;
  String? dangerTypeName;
  String? nickName;
  String? phone;
  String? cont;
  String? treatment;
  String? createTime;
  dynamic reviewTime;
  int? status;

  DangerResult(
      {int? id,
      String? unitName,
      String? buildingName,
      String? floorNumber,
      String? roomNumber,
      String? dangerTypeName,
      String? nickName,
      String? phone,
      String? cont,
      String? treatment,
      String? createTime,
      dynamic reviewTime,
      int? status});

  DangerResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unitName'];
    buildingName = json['buildingName'];
    floorNumber = json['floorNumber'];
    roomNumber = json['roomNumber'];
    dangerTypeName = json['dangerTypeName'];
    nickName = json['nickName'];
    phone = json['phone'];
    cont = json['cont'];
    treatment = json['treatment'];
    createTime = json['createTime'];
    reviewTime = json['reviewTime'];
    status = json['status'];
  }

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

class DangerParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  dynamic type;
  int status = 0;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'type': type,
        'status': status,
      };
  void change() {
    notifyListeners();
  }
}

// 风险
class RiskCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<RiskResult>? result;
  int? fromRow;

  RiskCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<RiskResult>? result,
      int? fromRow});

  RiskCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <RiskResult>[];
      json['result'].forEach((v) {
        result!.add(RiskResult.fromJson(v));
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

class RiskResult {
  int? id;
  String? unitName;
  String? warnSource;
  int? warnType;
  String? warnContent;
  double? warnValue;
  dynamic standardValue;
  dynamic relieveWarnValue;
  String? startTime;
  dynamic endTime;
  int? warnStatus;

  RiskResult(
      {int? id,
      String? unitName,
      String? warnSource,
      int? warnType,
      String? warnContent,
      double? warnValue,
      dynamic standardValue,
      dynamic relieveWarnValue,
      String? startTime,
      dynamic endTime,
      int? warnStatus});

  RiskResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unitName'];
    warnSource = json['warnSource'];
    warnType = json['warnType'];
    warnContent = json['warnContent'];
    warnValue = json['warnValue'];
    standardValue = json['standardValue'];
    relieveWarnValue = json['relieveWarnValue'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    warnStatus = json['warnStatus'];
  }

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

class RiskParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  dynamic warnType;
  int warnStatus = 1;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'warnType': warnType,
        'warnStatus': warnStatus,
      };
  void change() {
    notifyListeners();
  }
}

// 提醒
class ReminfCase {
  int? currentPage;
  int? totalPage;
  int? totalRow;
  int? pageSize;
  String? orderByClause;
  bool? needCount;
  List<ReminfResult>? result;
  int? fromRow;

  ReminfCase(
      {int? currentPage,
      int? totalPage,
      int? totalRow,
      int? pageSize,
      String? orderByClause,
      bool? needCount,
      List<ReminfResult>? result,
      int? fromRow});

  ReminfCase.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPage = json['totalPage'];
    totalRow = json['totalRow'];
    pageSize = json['pageSize'];
    orderByClause = json['orderByClause'];
    needCount = json['needCount'];
    if (json['result'] != null) {
      result = <ReminfResult>[];
      json['result'].forEach((v) {
        result!.add(ReminfResult.fromJson(v));
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

class ReminfResult {
  String? unitName;
  int? type;
  String? source;
  String? content;
  int? happenTime;

  ReminfResult(
      {String? unitName,
      int? type,
      String? source,
      String? content,
      int? happenTime});

  ReminfResult.fromJson(Map<String, dynamic> json) {
    unitName = json['unitName'];
    type = json['type'];
    source = json['source'];
    content = json['content'];
    happenTime = json['happenTime'];
  }

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

class ReminfParams extends ChangeNotifier {
  dynamic unitId;
  int currentPage = 1;
  int pageSize = 10;
  dynamic beginTime;
  dynamic endTime;
  dynamic type;

  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'currentPage': currentPage,
        'pageSize': pageSize,
        'beginTime': beginTime,
        'endTime': endTime,
        'type': type
      };
  void change() {
    notifyListeners();
  }
}
