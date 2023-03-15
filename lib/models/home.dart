class Params {
  int? unitId;
  int type = 1;
  Map<String, dynamic> toJson() => {
        'unitId': unitId,
        'type': type,
      };
}

class DeviceParams {
  int? unitId;
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
  String completionRate;
  // 额定任务
  int ratedTasks;
  // 完成任务
  int completionTasks;
  // 巡检路线
  int inspectRoutes;
  // 巡检人数
  int inspectNumber;

  InspectStats({
    required this.completionRate,
    required this.ratedTasks,
    required this.completionTasks,
    required this.inspectRoutes,
    required this.inspectNumber,
  });

  InspectStats.fromJson(Map<String, dynamic> json)
      : completionRate = json['completionRate'],
        ratedTasks = json['ratedTasks'],
        completionTasks = json['completionTasks'],
        inspectRoutes = json['inspectRoutes'],
        inspectNumber = json['inspectNumber'];

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
