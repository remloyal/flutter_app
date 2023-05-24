
import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/message.dart';
import 'package:fire_control_app/models/response.dart';

class MessageApi extends ListApi<MessageResponse, MessageParam> {
  @override
  Future<MessageResponse> loadList(MessageParam params) async {
    var response = await Http.dio
        .get('/mobile/my/messages', queryParameters: params.toJson());
    return MessageResponse.fromJson(response.data);
  }

  //活动详情
  static Future<NoticeDetail> getNoticeDetail(int id) async {
    var response = await Http.dio
        .get('/mobile/my/messageDetails', queryParameters: {'id': id});
    return NoticeDetail.fromJson(response.data['data']);
  }

  //公告详情
  static Future<ActivityDetail> getActivityDetail(int id) async {
    var response = await Http.dio
        .get('/mobile/my/messageDetails', queryParameters: {'id': id});
    return ActivityDetail.fromJson(response.data['data']);
  }

  //批量读
  static Future<FcResponse> read(int type) async {
    var response = await Http.dio.get('/mobile/my/readMessages',
        queryParameters: {'type': type});
    return FcResponse.fromJson(response.data);
  }
}