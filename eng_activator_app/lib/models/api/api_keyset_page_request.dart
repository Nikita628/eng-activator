class KeysetPageRequest {
  late int pageSize = 10;

  KeysetPageRequest({
    int pageSize = 10,
  }) {
    this.pageSize = pageSize;
  }

  Map<String, dynamic> toJson() {
    return {
      "pageSize": pageSize,
    };
  }
}