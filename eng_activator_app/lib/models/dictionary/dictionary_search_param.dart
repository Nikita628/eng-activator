class DictionarySearchParam {
  late String searchTerm = '';

  DictionarySearchParam(String searchTerm) {
    this.searchTerm = searchTerm;
  }

  Map<String, dynamic> toJson() {
    return {
      "searchTerm": searchTerm,
    };
  }
}