import 'package:eng_activator_app/models/auth/auth_response.dart';
import 'package:eng_activator_app/models/auth/login_data.dart';
import 'package:eng_activator_app/models/auth/signup_data.dart';
import 'package:eng_activator_app/services/api_clients/base_api_client.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiClient extends BaseApiClient {
  final Uri _loginUrl = Uri.http(AppConstants.getApiUrl(), '/api/auth/login');
  final Uri _signupUrl = Uri.http(AppConstants.getApiUrl(), '/api/auth/signup');

  Future<void> signup(SignupDto param, BuildContext context) async {
    var response = await executeHttp(() {
      return http.post(_signupUrl, body: json.encode(param), headers: AppConstants.apiHeaders);
    }, context);

    if (response.statusCode != 200) {
      throw createApiException(response.body);
    }
  }

  Future<AuthResponse> login(LoginDto param, BuildContext context) async {
    var response = await executeHttp(() {
      return http.post(_loginUrl, body: json.encode(param), headers: AppConstants.apiHeaders);
    }, context);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return AuthResponse.fromJson(map);
    } else {
      throw createApiException(response.body);
    }
  }
}
