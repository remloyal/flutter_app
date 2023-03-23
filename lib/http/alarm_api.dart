import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/alarm_entity.dart';

class AlarmApi {
  // 火情列表
  static useFireList(FireParams params) async {
    var response = await Http.dio
        .get('/mobile/fire/list', queryParameters: params.toJson());
    return FireCase.fromJson(response.data);
  }

  // 设备告警列表
  static useAlarmList(AlarmParams params) async {
    var response = await Http.dio
        .get('/mobile/alarm/list', queryParameters: params.toJson());
    return AlarmCase.fromJson(response.data);
  }

  // 设备故障列表
  static useFaultList(FaultParams params) async {
    var response = await Http.dio
        .get('/mobile/alarm/list', queryParameters: params.toJson());
    return FaultCase.fromJson(response.data);
  }

  // 隐患列表
  static useTroubleList(TroubleParams params) async {
    var response = await Http.dio
        .get('/mobile/trouble/list', queryParameters: params.toJson());
    return TroubleCase.fromJson(response.data);
  }

  // 危险品列表
  static useDangerList(DangerParams params) async {
    var response = await Http.dio
        .get('/mobile/danger/list', queryParameters: params.toJson());
    return DangerCase.fromJson(response.data);
  }

  // 风险列表
  static useRiskList(RiskParams params) async {
    var response = await Http.dio
        .get('/mobile/warn/list', queryParameters: params.toJson());
    return RiskCase.fromJson(response.data);
  }

  // 提醒列表
  static useRemindList(ReminfParams params) async {
    var response = await Http.dio
        .get('/mobile/remind/list', queryParameters: params.toJson());
    return ReminfCase.fromJson(response.data);
  }
}
