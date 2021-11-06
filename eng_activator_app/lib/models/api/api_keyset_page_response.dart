import 'package:eng_activator_app/shared/functions.dart';

class KeysetPageResponse<T>{
  late bool hasMoreItems = false;
  late List<T> items = [];

  KeysetPageResponse.fromJson(Map<String, dynamic> json, T Function(dynamic item) itemConverter) {
    hasMoreItems = json["hasMoreItems"];
    items = Converter.convertToList(json, "items", itemConverter);
  }
}