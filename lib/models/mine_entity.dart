class Info {
  String unitName;
  String nickName;
  String cellPhone;
  String roleName;
  String createTime;
  String reviewTime;
  String reviewer;
  String headImgUrl;
  int message;

  Info(
      {required this.unitName,
      required this.nickName,
      required this.cellPhone,
      required this.roleName,
      required this.createTime,
      required this.reviewTime,
      required this.reviewer,
      required this.headImgUrl,
      required this.message});

  Info.fromJson(Map<String, dynamic> json)
      : unitName = json['unitName'],
        nickName = json['nickName'],
        cellPhone = json['cellPhone'],
        roleName = json['roleName'],
        createTime = json['createTime'] ?? '',
        reviewTime = json['reviewTime'] ?? '',
        reviewer = json['reviewer'] ?? '',
        headImgUrl = json['headImgUrl'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
        'unitName': unitName,
        'nickName': nickName,
        'cellPhone': cellPhone,
        'roleName': roleName,
        'createTime': createTime,
        'reviewTime': reviewTime,
        'reviewer': reviewer,
        'headImgUrl': headImgUrl,
        'message': message,
      };
}

class MineMailItem {
  int id;
  String unitName;
  String nickName;
  String cellPhone;
  String roleName;
  String headImgUrl;
  String group;
  bool online;
  int onlineType;

  MineMailItem(
      {required this.id,
      required this.unitName,
      required this.nickName,
      required this.cellPhone,
      required this.roleName,
      required this.headImgUrl,
      required this.group,
      required this.online,
      required this.onlineType});

  MineMailItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        unitName = json['unitName'],
        nickName = json['nickName'],
        cellPhone = json['cellPhone'],
        roleName = json['roleName'],
        headImgUrl = json['headImgUrl'],
        group = json['group'],
        online = json['online'],
        onlineType = json['onlineType'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'unitName': unitName,
        'nickName': nickName,
        'cellPhone': cellPhone,
        'roleName': roleName,
        'headImgUrl': headImgUrl,
        'group': group,
        'online': online,
        'onlineType': onlineType,
      };
}
