class ApiPageRequest {
  late int pageNumber = 1;
  late int pageSize = 10;
  late String sortProp = "id";
  late String sortDirection = "asc";

  ApiPageRequest({
    int pageNumber = 1,
    int pageSize = 10,
    String sortProp = "id",
    String sortDirection = "asc",
  }) {
    this.pageNumber = pageNumber;
    this.pageSize = pageSize;
    this.sortProp = sortProp;
    this.sortDirection = sortDirection;
  }

  Map<String, dynamic> toJson() {
    return {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "sortProp": sortProp,
      "sortDirection": sortDirection,
    };
  }
}
