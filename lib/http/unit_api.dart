import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/unit.dart';

class UnitApi {

  static Future<List<Unit>> getUnitList() async {
    var response = await Http.dio.get('/mobile/unit/select');
    List<dynamic> data = response.data['data'];
    List<Unit> list = data.map((e) => Unit.fromJson(e)).toList();
    return list;
  }
}