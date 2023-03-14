import 'dart:convert';
import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/main.dart';

class LoginService {
  final appUrl = 'https://api.zhxf.ltd';
  final apiInfo = Global.profile.apiInfo;

  // 获取用户单位
  getUserUnits(String user) async {
    var result = await Http.request('$appUrl/project/listByUser',
        method: DioMethod.get, params: {'username': user});
    return result['data'];
  }

  getCode(String username, String? serial) async {
    var result = await Http.request('${apiInfo.baseUrl}/login/code',
        method: DioMethod.get,
        params: {'username': username, 'serial': serial});
    return jsonDecode(result);
  }

  preCheck(String username) async {
    var result = await Http.request('${apiInfo.baseUrl}/login/preCheck',
        method: DioMethod.get, params: {'phone': username});
    return jsonDecode(result);
  }

  check(String username, String serial) async {
    var result = await Http.request('${apiInfo.baseUrl}/login/check',
        method: DioMethod.get,
        params: {'username': username, 'serial': serial});
    return result['data'];
  }

  getCaptcha(String serial) async {
    var result = await Http.request('${apiInfo.baseUrl}/captcha/img',
        method: DioMethod.get, params: {'serial': serial});
    return result['data'];
  }

  verifyCaptcha(String serial, String code) async {
    var result = await Http.request('${apiInfo.baseUrl}/captcha/valid',
        method: DioMethod.get, params: {'code': code, 'serial': serial});
    return result['data'];
  }

  login(String username, String code, String serial) async {
    var result = await Http.request('${apiInfo.baseUrl}/login/phone',
        method: DioMethod.get,
        params: {'username': username, 'code': code, 'serial': serial});
    return jsonDecode(result);
  }

  // 注册相关

  // 获取注册验证码
  getProjectByCode(String code) async {
    var result = await Http.request('$appUrl/project/getByCode',
        method: DioMethod.get, params: {'code': code});
    return isMap(result);
  }

  getRegisterCode(String url, String username, String serial) async {
    var result = await Http.request('$url/reg/code',
        method: DioMethod.get,
        params: {'username': username, 'serial': serial});
    return isMap(result);
  }

  registerPreCheck(String url, String username) async {
    var result = await Http.request('$url/reg/preCheck/phone',
        method: DioMethod.get, params: {'cellPhone': username});
    return isMap(result);
  }

  registerCheck(String url, String username) async {
    var result = await Http.request('$url/reg/check/phone/registered',
        method: DioMethod.get, params: {'cellPhone': username});
    return isMap(result);
  }

  getRegisterUnitId(String url, String code) async {
    var result = await Http.request('$url/reg/getUnitByCode',
        method: DioMethod.get, params: {'code': code});
    print('isMap(result) ${isMap(result)}');
    return isMap(result);
  }

  register(String url, String username, String nickName, String code,
      int unitId, String serial) async {
    var result =
        await Http.request('$url/reg/register', method: DioMethod.get, params: {
      'username': username,
      'nickName': nickName,
      'code': code,
      'unitId': unitId,
      'serial': serial
    });
    return jsonDecode(result);
  }

  // 退出登录
  logout() async {
    var result =
        await Http.request('${apiInfo.baseUrl}/logout', method: DioMethod.get);
    return result['data'];
  }

  // 注销账号
  getUnregisterCode() async {
    var result = await Http.request(
        '${apiInfo.baseUrl}/mobile/my/cancellation/code',
        method: DioMethod.get);
    return result['data'];
  }

  getImage(String serial, String? url) async {
    var result = await Http.request(
        url != '' ? '$url/slider/img' : '${apiInfo.baseUrl}/slider/img',
        method: DioMethod.get,
        params: {'serial': serial});
    return isMap(result);
  }

  getValid(String serial, String code, String? url) async {
    var result = await Http.request(
        url != '' ? '$url/slider/valid' : '${apiInfo.baseUrl}/slider/valid',
        method: DioMethod.get,
        params: {'serial': serial, 'code': code});
    return isMap(result);
  }

  settingInfo(data) {
    print('用户登录信息： $data');
    Global.profile.apiInfo.ticket = data['ticket'];
    Global.profile.apiInfo.token = data['token'];
    Global.profile.apiInfo.user = data['user'];
    Global.profile.apiInfo.userId = data['user']['id'].toString();
    Global.profile.apiInfo.userUnit = data['user']['unitId'].toString();
    Global.profile.apiInfo.appKey = data['appKey'];
    Global.profile.apiInfo.voice = true;
    Global.profile.apiInfo.pronunciation = true;
    Global.profile.apiInfo.shock = true;
    Global.profile.isLogin = true;
    Http.dio.options.baseUrl = Global.profile.apiInfo.baseUrl;
    Global.setBaseUrl();
    Global.saveProfile();
    print('保存用户登录信息： ${Global.profile.apiInfo}');
  }

  // 退出登录
  static clearInfo() {
    navigatorKey.currentState?.pushReplacementNamed('login');
    Global.profile.apiInfo.ticket = '';
    Global.profile.apiInfo.token = '';
    Global.profile.apiInfo.user = {};
    Global.profile.apiInfo.userId = '';
    Global.profile.apiInfo.userUnit = '';
    Global.profile.apiInfo.appKey = '';
    Global.profile.apiInfo.voice = true;
    Global.profile.apiInfo.pronunciation = true;
    Global.profile.apiInfo.shock = true;
    Global.profile.isLogin = false;
    Http.dio.options.baseUrl = '';
    Global.setBaseUrl();
    Global.saveProfile();
  }

  // 判断类型
  isMap(data) {
    if (data is Map) {
      return data;
    } else {
      return jsonDecode(data);
    }
  }
}
