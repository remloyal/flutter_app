import 'package:dio/dio.dart';
import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/home.dart';

class HomeApi {
  /// 告警统计
  static Future<AlarmStats> useAlarmStats(Params param) async {
    var response = await Http.dio.get('/mobile/statistics/alarm', queryParameters: param.toJson());
    return AlarmStats.fromJson(response.data['data']);
  }

  // 巡检统计
  static Future<InspectStats> useInspectStats(Params param) async {
    var response = await Http.dio.get('/mobile/statistics/inspection', queryParameters: param.toJson());
    return InspectStats.fromJson(response.data['data']);
  }

  // 巡检统计
  static Future<DeviceStats> useDeviceStats(DeviceParams param) async {
    var response = await Http.dio.get('/mobile/statistics/device', queryParameters: param.toJson());
    return DeviceStats.fromJson(response.data['data']);
  }

  // 附件上传
  static uploadFile(int id, FormData param, Function(int, double) progressCallback) async {
    var response = await Http.dio.post(
      '/mobile/upload/attachments',
      data: param,
      onSendProgress: (count, total) {
        double persent = count / total;
        print(persent);
        progressCallback(id, persent);
      },
    );
    return response.data;
  }

  // 危险品类型
  static Future<List<DangerType>> getDangerType() async {
    var response = await Http.dio.get('/mobile/danger/types');
    List data = response.data['data'];
    return data.map((e) {
      return DangerType.fromJson(e);
    }).toList();
  }

  // 火情上报
  static reportFire(FileUpdateParam param) async {
    var response = await Http.dio.post('/mobile/fire/upload', queryParameters: param.toJson());
    return response.data;
  }

  // 隐患上报

  static reportTrouble(TroubleUpdateParam param) async {
    var response = await Http.dio.post('/mobile/trouble/upload', queryParameters: param.toJson());
    return response.data;
  }

  // 危险品上报

  static reportDanger(DangerUpdateParam param) async {
    var response = await Http.dio.post('/mobile/danger/upload', queryParameters: param.toJson());
    return response.data;
  }
}
