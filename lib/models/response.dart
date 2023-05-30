class FcResponse {
  int code;
  String? message;
  dynamic data;

  FcResponse.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        data = json['data'];
}

class FcWebResponse {
  int status;
  int errorCode;
  String? message;
  String? field;
  dynamic data;

  FcWebResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        errorCode = json['errorCode'],
        message = json['message'],
        field = json['field'],
        data = json['data'];
}

abstract class ListResponse<T> {
  int currentPage;
  int totalRow;
  int totalPage;
  List<dynamic>? result;

  ListResponse.fromJson(Map<String, dynamic> json)
      : currentPage = json['currentPage'] ?? 1,
        totalRow = json['totalRow'] ?? 0,
        totalPage = json['totalPage'] ?? 0,
        result = json['result'] ?? [];

  List<T> get records => result!.map((e) => generateRecord(e)).toList().cast<T>();

  T generateRecord(Map<String, dynamic> data);
}