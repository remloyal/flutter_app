/// 单位
class Unit {
  int unitId;
  String name;

  double pointX;
  double pointY;

  double score;

  Unit.fromJson(Map<String, dynamic> json)
      : unitId = json['id'],
        name = json['name'],
        pointX = json['pointX'] ?? 0,
        pointY = json['pointY'] ?? 0,
        score = json['score'];
}

// 建筑
class Building {
  int? id;
  String? name;
  double? pointX;
  double? pointY;

  Building({this.id, this.name, this.pointX, this.pointY});

  Building.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pointX = json['pointX'];
    pointY = json['pointY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['pointX'] = pointX;
    data['pointY'] = pointY;
    return data;
  }
}

// 楼层
class Floors {
  int? id;
  String? name;
  String? svgUrl;

  Floors({this.id, this.name, this.svgUrl});

  Floors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    svgUrl = json['svgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['svgUrl'] = svgUrl;
    return data;
  }
}

// 房间
class Rooms {
  int? id;
  String? name;

  Rooms({this.id, this.name});

  Rooms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
