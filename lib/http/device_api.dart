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
}
