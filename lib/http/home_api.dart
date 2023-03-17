import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/home.dart';

class HomeApi {
  /// 告警统计
  static Future<AlarmStats> useAlarmStats(Params param) async {
    var response = await Http.dio
        .get('/mobile/statistics/alarm', queryParameters: param.toJson());
    return AlarmStats.fromJson(response.data['data']);
  }

  // 巡检统计
  static Future<InspectStats> useInspectStats(Params param) async {
    var response = await Http.dio
        .get('/mobile/statistics/inspection', queryParameters: param.toJson());
    return InspectStats.fromJson(response.data['data']);
  }

  // 巡检统计
  static Future<DeviceStats> useDeviceStats(DeviceParams param) async {
    var response = await Http.dio
        .get('/mobile/statistics/device', queryParameters: param.toJson());
    return DeviceStats.fromJson(response.data['data']);
  }
}
