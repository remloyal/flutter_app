/// 接口相关配置实体
class ApiInfo {
  late String appDomain = '';

  // 登录的token
  String token = "286be7edeffe09a618944413c4ffbadd";
  // 登录的ticket
  String ticket = "14097eeba8854646a12b088253bae89a";

  String userId = "1915";

  String userUnit = "1915";
  // 应用key
  String appKey = "develop_test";
  // 接口域名
  String baseUrl = "https://api-dev.zhxf.ltd";
  // 图片域名
  String imgUrl = "https://img-dev.zhxf.ltd";

  //系统设置信息
  bool voice = true;
  bool pronunciation = true;
  bool shock = true;
  bool message = false;

  // 用户信息
  Map user = {};

  ApiInfo();

  ApiInfo.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        ticket = json['ticket'],
        appKey = json['appKey'],
        baseUrl = json['baseUrl'],
        imgUrl = json['imgUrl'],
        userId = json['userId'],
        userUnit = json['userUnit'],
        voice = json['voice'] ?? true,
        pronunciation = json['pronunciation'] ?? true,
        shock = json['shock'] ?? true,
        message = json['message'] ?? false,
        user = json['user'] ?? {};

  Map<String, dynamic> toJson() => {
        'token': token,
        'ticket': ticket,
        'appKey': appKey,
        'baseUrl': baseUrl,
        'imgUrl': imgUrl,
        'userId': userId,
        'userUnit': userUnit,
        'voice': voice,
        'pronunciation': pronunciation,
        'shock': shock,
        'user': user,
        'message': message
      };
}
