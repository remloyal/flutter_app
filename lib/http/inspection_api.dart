import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/inspection.dart';

class InspectionApi {
  static Future<RouteResponse> getInspectionList(RouteParam param) async {
    var response = await Http.dio
        .get('/mobile/inspection/tasks', queryParameters: param.toJson());
    return RouteResponse.fromJson(response.data);
  }

  static Future<PlanCase> getReceiveTaskList(PlanParam param) async {
    var response = await Http.dio
        .get('/mobile/inspection/receives', queryParameters: param.toJson());
    return PlanCase.fromJson(response.data['data']);
  }
}
