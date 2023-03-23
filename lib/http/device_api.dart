import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/device_entity.dart';

class DeviceApi {
  static useDeviceList(DeviceParams params) async {
    var response = await Http.dio
        .get('/mobile/device/list', queryParameters: params.toJson());
    return DeviceList.fromJson(response.data);
  }
}