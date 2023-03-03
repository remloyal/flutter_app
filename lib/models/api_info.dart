import 'package:fire_control_app/common/global.dart';

/// 接口相关配置实体
class ApiInfo {
  final Global global = Global();
  late String appDomain = '';

  // 登录的token
  String token = "2a75c6fd483822569b4d75941f9d9ccf";
  // 登录的ticket
  String ticket = "78a5ac1bdc6448168a97dfce0d40fa47";

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

  ApiInfo();

  ApiInfo.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        ticket = json['ticket'],
        appKey = json['appKey'],
        baseUrl = json['baseUrl'],
        imgUrl = json['imgUrl'],
        userId = json['userId'],
        userUnit = json['userUnit'],
        voice = json['voice'],
        pronunciation = json['pronunciation'],
        shock = json['shock'];

  Map<String, String> toJson() => {
        'token': token,
        'ticket': ticket,
        'appKey': appKey,
        'baseUrl': baseUrl,
        'imgUrl': imgUrl,
        'userId': userId,
        'userUnit': userUnit
      };
}
