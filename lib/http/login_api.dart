import 'dart:convert';
import 'package:fire_control_app/http/Http.dart';
import 'package:fire_control_app/common/global.dart';

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
    return result['data'];
  }

  registerPreCheck(String url, String username) async {
    var result = await Http.request('$url/reg/preCheck/phone',
        method: DioMethod.get, params: {'cellPhone': username});
    return result['data'];
  }

  registerCheck(String url, String username) async {
    var result = await Http.request('$url/reg/check/phone/registered',
        method: DioMethod.get, params: {'cellPhone': username});
    return result['data'];
  }

  getRegisterUnitId(String url, String code) async {
    var result = await Http.request('$url/reg/getUnitByCode',
        method: DioMethod.get, params: {'code': code});
    return result['data'];
  }

  register(String url, String param) async {
    var result = await Http.request('$url/reg/register',
        method: DioMethod.get, params: {'code': param});
    return result['data'];
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
    var result = await Http.request('${apiInfo.baseUrl}/slider/img',
        method: DioMethod.get, params: {'serial': serial});
    return jsonDecode(result);
  }

  getValid(String serial, String code, String? url) async {
    var result = await Http.request('${apiInfo.baseUrl}/slider/valid',
        method: DioMethod.get, params: {'serial': serial, 'code': code});
    return jsonDecode(result);
  }

  settingInfo(data) {
    Global.profile.apiInfo.ticket = data['ticket'];
    Global.profile.apiInfo.userId = data['user']['id'].toString();
    Global.profile.apiInfo.userUnit = data['user']['unitId'].toString();
    Global.profile.apiInfo.appKey = data['appKey'];
    Global.profile.apiInfo.voice = true;
    Global.profile.apiInfo.pronunciation = true;
    Global.profile.apiInfo.shock = true;
    Global.profile.isLogin = true;
    Global.setBaseUrl();
    Global.saveProfile();
    print('profile  ${Global.profile.apiInfo}');
  }
}
