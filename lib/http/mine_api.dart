import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/mine_entity.dart';

class MineApi {
  static useMyInfo() async {
    var response = await Http.dio.get('/mobile/my/info');
    return Info.fromJson(response.data['data']);
  }

  static Future<List<MineMailItem>> useMailList() async {
    var response = await Http.dio.get('/mobile/addressBook/list');
    List data = response.data['data'];
    List<MineMailItem> originalList = [];
    for (var i = 0; i < data.length; i++) {
      originalList.add(MineMailItem.fromJson(data[i]));
    }
    return originalList;
  }
}
