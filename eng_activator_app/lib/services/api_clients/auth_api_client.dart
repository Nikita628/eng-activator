import 'package:eng_activator_app/models/auth/auth_response.dart';
import 'package:eng_activator_app/models/auth/login_data.dart';
import 'package:eng_activator_app/models/auth/signup_data.dart';
import 'package:eng_activator_app/shared/constants.dart';
import 'package:eng_activator_app/shared/functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthApiClient {
  final Uri _loginUrl = Uri.https(AppConstants.apiUrl, '/api/auth/login');
  final Uri _signupUrl = Uri.https(AppConstants.apiUrl, '/api/auth/signup');

  Future<AuthResponse> signup(SignupDto param) async {
    var response = await http.post(_signupUrl, body: json.encode(param), headers: AppConstants.apiHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return AuthResponse.fromJson(map);
    } else {
      throw createApiException(response.body);
    }
  }

  Future<AuthResponse> login(LoginDto param) async {
    var response = await http.post(_loginUrl, body: json.encode(param), headers: AppConstants.apiHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      return AuthResponse.fromJson(map);
    } else {
      throw createApiException(response.body);
    }
  }
}
