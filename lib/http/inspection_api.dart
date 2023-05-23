import 'package:dio/dio.dart';
import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/models/response.dart';

class RouteApi extends ListApi<RouteResponse, RouteParam> {
  @override
  Future<RouteResponse> loadList(RouteParam params) async {
    var response = await Http.dio
        .get('/mobile/inspection/tasks', queryParameters: params.toJson());
    return RouteResponse.fromJson(response.data);
  }

  // 路线详情
  static Future<RouteDetail> getRouteDetail(int id) async {
    var response = await Http.dio
        .get('/mobile/inspection/taskDetails', queryParameters: {'taskId': id});
    return RouteDetail.fromJson(response.data['data']);
  }
}

class TaskApi extends ListApi<PlanResponse, TaskParam> {
  @override
  Future<PlanResponse> loadList(TaskParam params) async {
    var response = await Http.dio
        .get('/mobile/inspection/receives', queryParameters: params.toJson());
    return PlanResponse.fromJson(response.data['data']);
  }

  // 任务详情
  static Future<TaskDetail> getTaskDetail(int id) async {
    var response = await Http.dio.get('/mobile/inspection/receiveDetails',
        queryParameters: {'taskId': id});
    return TaskDetail.fromJson(response.data['data']);
  }

  // 领取任务
  static Future<FcResponse> receive(int id) async {
    var response = await Http.dio.get('/mobile/inspection/receive',
        queryParameters: {'taskId': id});
    return FcResponse.fromJson(response.data);
  }

  //巡检打卡
  static Future<FcResponse> inspectionPunch(PunchParam param) async {
    var response = await Http.dio.post('/mobile/inspection/punch',
        queryParameters: param.toJson());
    return FcResponse.fromJson(response.data);
  }

  //控制室打卡
  static Future<FcResponse> controlPunch(String url) async {
    var response = await Http.dio.post('/mobile/workPunch/punch',
        queryParameters: { 'code': url });
    return FcResponse.fromJson(response.data);
  }

  //上下班打卡
  static Future<FcResponse> workPunch(String url) async {
    var response = await Http.dio.post('/mobile/punch/punchByCode',
        queryParameters: { 'code': url });
    return FcResponse.fromJson(response.data);
  }
}
