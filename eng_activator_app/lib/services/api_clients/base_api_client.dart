import 'dart:convert';
import 'dart:io';
import 'package:eng_activator_app/models/api/api_error_response.dart';
import 'package:eng_activator_app/shared/api_exception.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BaseApiClient {
  Future<Response> executeHttp(Future<Response> Function() func, BuildContext context) async {
    try {
      var response = await func();
      return response;
    } on SocketException {
      await showErrorDialog("No internet connection", context);
      throw Exception("Something went wrong");
    }
  }

  ApiResponseException createApiException(String responseBody) {
    Map<String, dynamic> err = jsonDecode(responseBody);
    return ApiResponseException(ApiErrorResponse.fromJson(err));
  }

  Map<String, String> createRequestHeaders(String token) {
    return {
      "content-type": "application/json",
      "Authorization": "Bearer $token",
      "utcOffset": DateTime.now().timeZoneOffset.inMinutes.toString(),
    };
  }
}
