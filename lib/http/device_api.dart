import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/device_entity.dart';

class DeviceApi extends ListApi<DeviceResponse, DeviceParams> {
  @override
  Future<DeviceResponse> loadList(DeviceParams params) async {
    var response = await Http.dio
        .get('/mobile/device/list', queryParameters: params.toJson());
    return DeviceResponse.fromJson(response.data);
  }

  // 获取设备类型
  static useDeviceTypes() async {
    var response = await Http.dio.get('/mobile/deviceType/list');
    return response.data['data'] ?? [];
  }

  // 危险品详情
  static Future<DeviceDetails> useDeviceDetails(int id) async {
    var response = await Http.dio
        .get('/mobile/device/detail', queryParameters: {'deviceId': id});
    return DeviceDetails.fromJson(response.data['data']);
  }

  // 实时数据
  static Future<List<RealTimeParam>> useDeviceAttributes(int deviceId) async {
    var response = await Http.dio.get('/mobile/device/attributes',
        queryParameters: {'deviceId': deviceId});
    late List<RealTimeParam> data = [];
    final List record = response.data['data'];
    for (var i = 0; i < record.length; i++) {
      data.add(RealTimeParam.fromJson(record[i]));
    }
    return data;
  }

  // 设备封停
  static Future setDevicStop(int id, {int? type, String? reason}) async {
    var response = await Http.dio.get('/mobile/device/stop',
        queryParameters: {'deviceId': id, 'type': type, 'reason': reason});
    return response.data;
  }

  // 设备解封
  static Future setDevicStart(int id) async {
    var response = await Http.dio
        .get('/mobile/device/start', queryParameters: {'deviceId': id});
    return response.data;
  }
}

// 设备事件
class DeviceEventApi extends ListApi<DeviceEventResponse, DeviceEventParams> {
  @override
  Future<DeviceEventResponse> loadList(DeviceEventParams params) async {
    var response = await Http.dio
        .get('/mobile/device/events', queryParameters: params.toJson());
    return DeviceEventResponse.fromJson(response.data);
  }
}

// 操作记录
class OperationLogApi
    extends ListApi<DeviceOperationLogResponse, OperationLogParams> {
  @override
  Future<DeviceOperationLogResponse> loadList(OperationLogParams params) async {
    var response = await Http.dio
        .get('/mobile/device/operation/logs', queryParameters: params.toJson());
    return DeviceOperationLogResponse.fromJson(response.data);
  }
}
