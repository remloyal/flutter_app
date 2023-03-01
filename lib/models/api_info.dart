import 'package:fire_control_app/common/global.dart';

/// 接口相关配置实体
class ApiInfo {
  final Global global = Global();
  late String appDomain = '';

  // 登录的token
  String token = "2a75c6fd483822569b4d75941f9d9ccf";
  // 登录的ticket
  String ticket = "78a5ac1bdc6448168a97dfce0d40fa47";
  // 应用key
  String appKey = "develop_test";
  // 接口域名
  String baseUrl = "https://api-dev.zhxf.ltd";
  // 图片域名
  String imgUrl = "https://img-dev.zhxf.ltd";

  ApiInfo();

  ApiInfo.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        ticket = json['ticket'],
        appKey = json['appKey'],
        baseUrl = json['baseUrl'],
        imgUrl = json['imgUrl'];

  Map<String, String> toJson() => {
        'token': token,
        'ticket': ticket,
        'appKey': appKey,
        'baseUrl': baseUrl,
        'imgUrl': imgUrl
      };
  init(String key) {
    print(key);
    // appDomain = global.getString('appDomain') as String;
    var domain = key.split('-');
    print(domain);
    baseUrl = 'https://api-${domain[1]}.zhxf.ltd';
    imgUrl = "https://img-${domain[1]}.zhxf.ltd";
    print('baseUrl: $baseUrl , imgUrl:  $imgUrl ');
  }
}
