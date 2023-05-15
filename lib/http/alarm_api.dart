import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/alarm_entity.dart';

class FireApi extends ListApi<FireResponse, FireParam> {
  @override
  Future<FireResponse> loadList(FireParam params) async {
    var response = await Http.dio
        .get('/mobile/fire/list', queryParameters: params.toJson());
    return FireResponse.fromJson(response.data);
  }

  // 火情详情
  static Future<FireDetail> getFireDetail(int id) async {
    var response =
    await Http.dio.get('/mobile/fire/details', queryParameters: {'id': id});
    return FireDetail.fromJson(response.data['data']);
  }
}

class AlarmApi extends ListApi<AlarmResponse, AlarmParam> {
  @override
  Future<AlarmResponse> loadList(AlarmParam params) async {
    var response = await Http.dio
        .get('/mobile/alarm/list', queryParameters: params.toJson());
    return AlarmResponse.fromJson(response.data);
  }

  // 告警故障详情
  static Future<AlarmDetail> getAlarmFaultDetail(int id) async {
    var response = await Http.dio
        .get('/mobile/alarm/details', queryParameters: {'id': id});
    return AlarmDetail.fromJson(response.data['data']);
  }
}

class TroubleApi extends ListApi<TroubleResponse, TroubleParam> {
  @override
  Future<TroubleResponse> loadList(TroubleParam params) async {
    var response = await Http.dio
        .get('/mobile/trouble/list', queryParameters: params.toJson());
    return TroubleResponse.fromJson(response.data);
  }

  // 隐患详情
  static Future<TroubleDetail> getTroubleDetail(int id) async {
    var response = await Http.dio
        .get('/mobile/trouble/details', queryParameters: {'id': id});
    return TroubleDetail.fromJson(response.data['data']);
  }
}

class DangerApi extends ListApi<DangerResponse, DangerParam> {
  @override
  Future<DangerResponse> loadList(DangerParam params) async {
    var response = await Http.dio
        .get('/mobile/danger/list', queryParameters: params.toJson());
    return DangerResponse.fromJson(response.data);
  }

  // 危险品详情
  static Future<DangerDetail> getDangerDetail(int id) async {
    var response = await Http.dio
        .get('/mobile/danger/details', queryParameters: {'id': id});
    return DangerDetail.fromJson(response.data['data']);
  }

  //危险品类型
  static Future<List<DangerType>> getDangerTypes() async {
    var response = await Http.dio.get('/mobile/danger/types');
    return (response.data['data'] ?? [])
        .map((e) => DangerType.fromJson(e))
        .toList(growable: false)
        .cast<DangerType>();
  }
}

class RiskApi extends ListApi<RiskResponse, RiskParam> {
  @override
  Future<RiskResponse> loadList(RiskParam params) async {
    var response = await Http.dio
        .get('/mobile/warn/list', queryParameters: params.toJson());
    return RiskResponse.fromJson(response.data);
  }
}

class RemindApi extends ListApi<RemindResponse, RemindParam> {
  @override
  Future<RemindResponse> loadList(RemindParam params) async {
    var response = await Http.dio
        .get('/mobile/remind/list', queryParameters: params.toJson());
    return RemindResponse.fromJson(response.data);
  }

}