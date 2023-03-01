import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/unit.dart';
import 'dart:convert';

class UnitApi {
  static Future<List<Unit>> getUnitList() async {
    var response = await Http.dio.get('/mobile/unit/select');
    var todo = jsonDecode(response.data);
    if (todo['code'] == 20013) {
      return [];
    } else {
      List<dynamic> data = todo['data'];
      List<Unit> list = data.map((e) => Unit.fromJson(e)).toList();
      return list;
    }
  }
}
