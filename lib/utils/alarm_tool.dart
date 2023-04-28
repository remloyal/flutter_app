final List troubleTypes = [
  {'name': '全部', 'value': ''},
  {'name': '损坏', 'value': 1},
  {'name': '人为风险', 'value': 2},
  {'name': '非人为风险', 'value': 3},
  {'name': '缺失', 'value': 4},
];

getTroubleTypeDesc(int? type) {
  for (var i = 0; i < troubleTypes.length; i++) {
    if (troubleTypes[i]['value'] == type) {
      return troubleTypes[i]['name'];
    }
  }
  return '';
}

// 风险类型
final List riskTypes = [
  {'text': '全部类型', 'value': ''},
  {'text': '设备故障风险', 'value': 1},
  {'text': '单位风险', 'value': 2},
  {'text': '建筑风险', 'value': 3},
];

getRiskTypeDesc(int type) {
  for (var i = 0; i < riskTypes.length; i++) {
    if (riskTypes[i]['value'] == type) {
      return riskTypes[i]['text'];
    }
  }
  return '';
}

// 提醒类型
final List remindTypes = [
  {'text': '全部类型', 'value': ''},
  {'text': '设备自检', 'value': 1},
  {'text': '设备布控', 'value': 2},
  {'text': '设备其他', 'value': 3},
  {'text': '设备消音', 'value': 4},
  {'text': '设备操作', 'value': 5},
  {'text': '设备离线', 'value': 6},
];

getRemindTypeDesc(int type) {
  for (var i = 0; i < remindTypes.length; i++) {
    if (remindTypes[i]['value'] == type) {
      return remindTypes[i]['text'];
    }
  }
  return '';
}
