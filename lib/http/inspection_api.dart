import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/inspection.dart';

class RouteApi extends ListApi<RouteResponse, RouteParam> {
  @override
  Future<RouteResponse> loadList(RouteParam params) async {
    var response = await Http.dio
        .get('/mobile/inspection/tasks', queryParameters: params.toJson());
    return RouteResponse.fromJson(response.data);
  }
}

class PlanApi extends ListApi<PlanResponse, PlanParam> {
  @override
  Future<PlanResponse> loadList(PlanParam params) async {
    var response = await Http.dio
        .get('/mobile/inspection/receives', queryParameters: params.toJson());
    return PlanResponse.fromJson(response.data['data']);
  }
}
