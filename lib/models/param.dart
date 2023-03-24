class Param {
  int currentPage;
  int pageSize;
  dynamic unitId;

  Param({this.currentPage = 1, this.pageSize = 10, this.unitId});

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'unitId': unitId,
      };
}
