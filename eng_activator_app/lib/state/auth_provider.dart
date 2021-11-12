import 'dart:async';
import 'dart:convert';
import 'package:eng_activator_app/models/auth/auth_response.dart';
import 'package:eng_activator_app/models/user.dart';
import 'package:eng_activator_app/shared/state/current_url_provider.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:eng_activator_app/widgets/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _authDataStorageKey = 'eng_activator_auth_data';

class AuthProvider with ChangeNotifier {
  String _token = '';
  DateTime? _tokenExpirationDate;
  User? _user;
  Timer? _autoLogoutTimer;

  String getToken() {
    return _token;
  }

  User? getUser() {
    return _user;
  }

  DateTime? getTokenExpirationDate() {
    return _tokenExpirationDate;
  }

  bool isUserAuthenticated() {
    var isTokenExpired = _tokenExpirationDate == null || DateTime.now().isAfter(_tokenExpirationDate as DateTime);
    return _token.isNotEmpty && !isTokenExpired && _user != null;
  }

  Future<void> setAuthData(AuthResponse authResponse) async {
    _token = authResponse.token;
    _user = authResponse.user;
    _tokenExpirationDate = authResponse.tokenExpirationDate;
    _autoLogout();
    await _saveAuthDataInLocalStorage();
  }

  Future<void> logout(BuildContext context) async {
    Provider.of<ActivityResponseProvider>(context, listen: false).resetState();
    Provider.of<ActivityProvider>(context, listen: false).resetState();
    Provider.of<CurrentUrlProvider>(context, listen: false).resetState();

    _token = '';
    _tokenExpirationDate = null;
    _user = null;
    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = null;

    await _removeAuthDataFromLocalStorage();

    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreenWidget()),
      (Route<dynamic> route) => false,
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_authDataStorageKey)) {
      return false;
    }

    var isLoggedIn = false;

    Map<String, dynamic> json = jsonDecode(prefs.getString(_authDataStorageKey) as String);
    var authData = AuthResponse.fromJson(json);

    if ((authData.tokenExpirationDate as DateTime).isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      _token = authData.token;
      _user = authData.user;
      _tokenExpirationDate = authData.tokenExpirationDate;
      _autoLogout();
      isLoggedIn = true;
    }

    return isLoggedIn;
  }

  Future<void> _removeAuthData() async {
    _token = '';
    _tokenExpirationDate = null;
    _user = null;
    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = null;
    await _removeAuthDataFromLocalStorage();

    notifyListeners();
  }

  void _autoLogout() {
    _autoLogoutTimer?.cancel();

    var secondsUntilExpiration = _tokenExpirationDate?.difference(DateTime.now().subtract(Duration(days: 1))).inSeconds;

    if (secondsUntilExpiration != null) {
      _autoLogoutTimer = Timer(Duration(seconds: secondsUntilExpiration), _removeAuthData);
    }
  }

  Future<void> _saveAuthDataInLocalStorage() async {
    try {
      var sharedPrefs = await SharedPreferences.getInstance();

      var authData = {
        "token": _token,
        "tokenExpirationDate": _tokenExpirationDate.toString(),
        "user": {
          "id": _user?.id,
          "name": _user?.name,
        }
      };

      await sharedPrefs.setString(_authDataStorageKey, jsonEncode(authData));
    } catch (e) {}
  }

  Future<void> _removeAuthDataFromLocalStorage() async {
    try {
      var sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.remove(_authDataStorageKey);
    } catch (e) {}
  }
}
