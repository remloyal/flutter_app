
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