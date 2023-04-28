import 'package:fire_control_app/http/http.dart';

class PushApi {

  static Future<String> getBaiduToken() async {
    var response = await Http.dio.get('/alarm/getAccessToken');
    var data = response.data['data'];
    if (data == null) return "";
    return data['accessToken'];
  }
}