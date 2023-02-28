import 'package:fire_control_app/models/api_info.dart';

/// 全局配置实体
class Profile {

  // 是否登录
  bool isLogin = true;

  // 登录的用户id
  int userId = 1915;

  // 登录之后，请求接口相关的信息
  ApiInfo apiInfo = ApiInfo();

  Profile();

  Profile.fromJson(Map<String, dynamic> json)
      : isLogin = json['isLogin'],
        userId = json['userId'],
        apiInfo = ApiInfo.fromJson(json['apiInfo']);

  Map<String, dynamic> toJson() => {
    'isLogin': isLogin,
    'userId': userId,
    'apiInfo': apiInfo.toJson()
  };
}