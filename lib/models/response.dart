import 'package:fire_control_app/models/inspection.dart';

class Response<T> {
  int currentPage = 1;
  int totalRow;
  int totalPage;
  int? pageSize = 10;
  String? orderByClause;
  bool? needCount;
  int? fromRow;
  List<T>? result;

  Response({
    this.currentPage = 1,
    this.totalRow = 0,
    this.totalPage = 0,
    this.result,
    this.fromRow,
    this.needCount,
    this.orderByClause,
    this.pageSize,
  });
}
