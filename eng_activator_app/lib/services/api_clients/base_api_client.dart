import 'dart:convert';
import 'dart:io';
import 'package:eng_activator_app/models/api/api_error_response.dart';
import 'package:eng_activator_app/shared/api_exception.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/enums.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BaseApiClient {
  Future<Response> executeHttp(Future<Response> Function() func, BuildContext context) async {
    try {
      var response = await func();

      if (response.statusCode != 200 && _isInNonProdEnvironment()) {
        await showErrorDialog("API ERROR (this is not displayed in production): ${response.body}", context);
      }

      return response;
    } on SocketException {
      await showErrorDialog("No internet connection", context);
      throw Exception("Something went wrong");
    } on Exception catch (e) {
      if (_isInNonProdEnvironment()) {
        await showErrorDialog("UNKNOWN ERROR (this is not displayed in production): ${e.toString()}", context);
      }
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

  bool _isInNonProdEnvironment() {
    return AppConstants.currentAppEnvironment == AppEnvironment.Local ||
        AppConstants.currentAppEnvironment == AppEnvironment.Development;
  }
}
