import 'dart:convert';
import 'package:eng_activator_app/models/api_error_response.dart';
import 'package:eng_activator_app/shared/api_exception.dart';

class Converter {
  static List<T> toList<T>(Map<String, dynamic> json, String prop) {
    var list = (json[prop] ?? []) as List;
    return list.map((e) => e as T).toList();
  }

  static List<T> convertToList<T>(Map<String, dynamic> json, String prop, T Function(dynamic) converter) {
    var list = (json[prop] ?? []) as List;
    return list.map((e) => converter(e)).toList();
  }
}

ApiResponseException createApiException(String responseBody) {
  Map<String, dynamic> err = jsonDecode(responseBody);
  return ApiResponseException(ApiErrorResponse.fromJson(err));
}

Map<String, String> createRequestHeaders(String token) {
  return {
    "content-type": "application/json",
    "Authorization": "Bearer $token"
  };
}