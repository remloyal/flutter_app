
import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';

class MessageParam extends Param {

  // 消息公告5 活动通知6
  int type = 5;
  // 未读1 已读2
  int status = 1;

  MessageParam() : super();

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'type': type,
    'status': status,
  };
}

class MessageResponse extends ListResponse<MessageItem> {

  MessageResponse.fromJson(super.json) : super.fromJson();

  @override
  MessageItem generateRecord(Map<String, dynamic> data) => MessageItem.fromJson(data);
}

class MessageItem {
  String content;
  int id;
  String receiveUnitName;
  String sendTime;
  int status;
  String title;
  int type;

  MessageItem.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        id = json['id'],
        receiveUnitName = json['receiveUnitName'],
        sendTime = json['sendTime'],
        status = json['status'],
        title = json['title'],
        type = json['type'];
}

class NoticeDetail {
  String content;
  String receiveUnitName;
  String sendTime;
  String senderName;
  String senderUnitName;
  int status;
  String title;
  int type;

  NoticeDetail.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        receiveUnitName = json['receiveUnitName'],
        sendTime = json['sendTime'],
        senderName = json['senderName'],
        senderUnitName = json['senderUnitName'],
        status = json['status'],
        title = json['title'],
        type = json['type'];
}

class ActivityDetail {
  int activeUserNumber;
  String buildingName;
  String content;
  int dangerSource;
  int fire;
  int levels;
  String location;
  String name;
  String startTime;
  String sendUserName;
  String? senderUnitName;
  String unitName;
  int smoking;

  ActivityDetail.fromJson(Map<String, dynamic> json)
      : activeUserNumber = json['activeUserNumber'],
        buildingName = json['buildingName'],
        content = json['content'],
        dangerSource = json['dangerSource'],
        fire = json['fire'],
        levels = json['levels'],
        location = json['location'],
        name = json['name'],
        startTime = json['startTime'],
        sendUserName = json['sendUserName'],
        senderUnitName = json['senderUnitName'],
        unitName = json['unitName'],
        smoking = json['smoking'];

}