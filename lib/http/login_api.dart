import 'dart:convert';

import 'package:fire_control_app/http/http.dart';

class LoginService {
  final http = Http();
  final appUrl = 'https://api.zhxf.ltd';

  // 获取用户单位
  getUserUnits(String user) async {
    var result = await http.request('$appUrl/project/listByUser',
        method: DioMethod.get, params: {'username': user});
    return result['data'];
  }

  getCode(String username, String? serial) async {
    var result = await http.request('${http.apiInfo.baseUrl}/login/code',
        method: DioMethod.get,
        params: {'username': username, 'serial': serial});
    return jsonDecode(result);
  }

  preCheck(String username) async {
    var result = await http.request('${http.apiInfo.baseUrl}/login/preCheck',
        method: DioMethod.get, params: {'phone': username});
    return jsonDecode(result);
  }

  check(String username, String serial) async {
    var result = await http.request('${http.apiInfo.baseUrl}/login/check',
        method: DioMethod.get,
        params: {'username': username, 'serial': serial});
    return result['data'];
  }

  getCaptcha(String serial) async {
    var result = await http.request('${http.apiInfo.baseUrl}/captcha/img',
        method: DioMethod.get, params: {'serial': serial});
    return result['data'];
  }

  verifyCaptcha(String serial, String code) async {
    var result = await http.request('${http.apiInfo.baseUrl}/captcha/valid',
        method: DioMethod.get, params: {'code': code, 'serial': serial});
    return result['data'];
  }

  login(String username, String code, String serial) async {
    var result = await http.request('${http.apiInfo.baseUrl}/login/phone',
        method: DioMethod.get,
        params: {'username': username, 'code': code, 'serial': serial});
    return jsonDecode(result);
  }

  // 注册相关

  // 获取注册验证码
  getProjectByCode(String code) async {
    var result = await http.request('$appUrl/project/getByCode',
        method: DioMethod.get, params: {'code': code});
    return result['data'];
  }

  registerPreCheck(String url, String username) async {
    var result = await http.request('$url/reg/preCheck/phone',
        method: DioMethod.get, params: {'cellPhone': username});
    return result['data'];
  }

  registerCheck(String url, String username) async {
    var result = await http.request('$url/reg/check/phone/registered',
        method: DioMethod.get, params: {'cellPhone': username});
    return result['data'];
  }

  getRegisterUnitId(String url, String code) async {
    var result = await http.request('$url/reg/getUnitByCode',
        method: DioMethod.get, params: {'code': code});
    return result['data'];
  }

  register(String url, String param) async {
    var result = await http.request('$url/reg/register',
        method: DioMethod.get, params: {'code': param});
    return result['data'];
  }

  // 退出登录
  logout() async {
    var result = await http.request('${http.apiInfo.baseUrl}/logout',
        method: DioMethod.get);
    return result['data'];
  }

  // 注销账号
  getUnregisterCode() async {
    var result = await http.request(
        '${http.apiInfo.baseUrl}/mobile/my/cancellation/code',
        method: DioMethod.get);
    return result['data'];
  }

  getImage(String serial, String? url) async {
    var result = await http.request(
        '${url?.isNotEmpty ?? false ? http.apiInfo.baseUrl : url}/slider/img',
        method: DioMethod.get,
        params: {'serial': serial});
    return jsonDecode(result);
  }

  getValid(String serial, String code, String? url) async {
    var result = await http.request(
        '${url?.isNotEmpty ?? false ? http.apiInfo.baseUrl : url}/slider/valid',
        method: DioMethod.get,
        params: {'serial': serial, 'code': code});
    return jsonDecode(result);
  }
}
