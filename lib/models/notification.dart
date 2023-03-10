
/// websocket推送的opt消息体
class NotifyMessage {
    String code;
    int type;
    String title;
    String description;
    String time;
    int messageId;
    int referenceId;
    int referenceUnitId;
    bool voice;
    bool popup;

    NotifyMessage.fromJson(Map<String, dynamic> json)
        : code = json['code'],
          type = json['type'],
          title = json['title'],
          description = json['description'],
          time = json['time'],
          messageId = json['messageId'],
          referenceId = json['referenceId'],
          referenceUnitId = json['referenceUnitId'],
          voice = json['voice'],
          popup = json['popup'];
}