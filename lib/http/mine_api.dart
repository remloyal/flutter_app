import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/mine_entity.dart';

class MineApi {
  static useMyInfo() async {
    var response = await Http.dio.get('/mobile/my/info');
    return Info.fromJson(response.data['data']);
  }
}
