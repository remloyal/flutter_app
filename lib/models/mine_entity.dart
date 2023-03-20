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
