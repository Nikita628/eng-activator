import 'package:eng_activator_app/shared/functions.dart';

class ApiPageResponse<T>{
  late int totalCount = 0;
  late List<T> items = [];

  ApiPageResponse.fromJson(Map<String, dynamic> json, T Function(dynamic item) itemConverter) {
    totalCount = json["totalCount"];
    items = Converter.convertToList(json, "items", itemConverter);
  }
}