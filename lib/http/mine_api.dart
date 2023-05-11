import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/mine_entity.dart';

class MineApi {
  static useMyInfo() async {
    var response = await Http.dio.get('/mobile/my/info');
    return Info.fromJson(response.data['data']);
  }

  static Future<List<MineMailItem>> useMailList() async {
    var response = await Http.dio.get('/mobile/addressBook/list');
    List data = response.data['data'];
    List<MineMailItem> originalList = [];
    for (var i = 0; i < data.length; i++) {
      originalList.add(MineMailItem.fromJson(data[i]));
    }
    return originalList;
  }
}

// 我的 火情
class MineFireApi extends ListApi<MineFireResponse, MineFireParams> {
  @override
  Future<MineFireResponse> loadList(MineFireParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/fires', queryParameters: params.toJson());
    return MineFireResponse.fromJson(response.data);
  }

  // 统计
  static Future<MineFireCount> useUserFireStats(
      MineFireCountParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/fireCount', queryParameters: params.toJson());
    return MineFireCount.fromJson(response.data['data']);
  }
}

// 我的 报警
class MineAlarmApi extends ListApi<MineAlarmResponse, MineAlarmParams> {
  @override
  Future<MineAlarmResponse> loadList(MineAlarmParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/alarms', queryParameters: params.toJson());
    return MineAlarmResponse.fromJson(response.data);
  }

  // 统计
  static Future<MineAlarmCount> useUserFireStats(
      MineAlarmCountParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/alarmCount', queryParameters: params.toJson());
    return MineAlarmCount.fromJson(response.data['data']);
  }
}

// 我的 巡检
class MineInspectionApi
    extends ListApi<MineInspectionResponse, MineInspectionParams> {
  @override
  Future<MineInspectionResponse> loadList(MineInspectionParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/inspections', queryParameters: params.toJson());
    return MineInspectionResponse.fromJson(response.data['data']);
  }

  // 统计
  static Future<MineInspectionCount> useUserInspectionStats(
      MineInspectionCountParams params) async {
    var response = await Http.dio.get('/mobile/workLog/inspectionCount',
        queryParameters: params.toJson());
    return MineInspectionCount.fromJson(response.data['data']);
  }
}

// 我的 隐患
class MineTroubleApi extends ListApi<MineTroubleResponse, MineTroubleParams> {
  @override
  Future<MineTroubleResponse> loadList(MineTroubleParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/troubles', queryParameters: params.toJson());
    return MineTroubleResponse.fromJson(response.data);
  }

  // 统计
  static Future<MineTroubleCount> useUserInspectionStats(
      MineTroubleCountParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/troubleCount', queryParameters: params.toJson());
    return MineTroubleCount.fromJson(response.data['data']);
  }
}

// 我的 危险品
class MineDangerApi extends ListApi<MineDangerResponse, MineDangerParams> {
  @override
  Future<MineDangerResponse> loadList(MineDangerParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/dangers', queryParameters: params.toJson());
    return MineDangerResponse.fromJson(response.data);
  }

  // 统计
  static Future<MineDangerCount> useUserInspectionStats(
      MineDangerCountParams params) async {
    var response = await Http.dio
        .get('/mobile/workLog/dangerCount', queryParameters: params.toJson());
    return MineDangerCount.fromJson(response.data['data']);
  }
}
