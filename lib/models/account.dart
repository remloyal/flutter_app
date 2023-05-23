
class LoginScanParam {
  String url;
  int scanStatus = 2;

  LoginScanParam(this.url);

  Map<String, dynamic> toJson() {
    return {
      'code': url,
      'scanStatus': scanStatus
    };
  }
}