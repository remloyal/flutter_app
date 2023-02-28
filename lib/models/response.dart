
class Response<T> {
  final int currentPage;
  final int totalRow;
  final int totalPage;
  final List<T> result;

  Response(this.currentPage, this.totalRow, this.totalPage, this.result);
}