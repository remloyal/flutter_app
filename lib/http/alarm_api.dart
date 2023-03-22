import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/alarm_entity.dart';

class AlarmApi {
  // 火情列表
  static useFireList(params) async {
    var response = await Http.dio
        .get('/mobile/fire/list', queryParameters: params.toJson());
    return FireCase.fromJson(response.data);
  }

  // 设备告警列表
  static useAlarmList(params) async {
    var response = await Http.dio
        .get('/mobile/alarm/list', queryParameters: params.toJson());
    return AlarmCase.fromJson(response.data);
  }

  // 设备故障列表
  static useFaultList(params) async {
    var response = await Http.dio
        .get('/mobile/alarm/list', queryParameters: params.toJson());
    return FaultCase.fromJson(response.data);
  }
}
