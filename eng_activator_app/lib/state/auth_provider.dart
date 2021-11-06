import 'dart:async';
import 'dart:convert';
import 'package:eng_activator_app/models/auth/auth_response.dart';
import 'package:eng_activator_app/models/user.dart';
import 'package:eng_activator_app/state/activity_provider.dart';
import 'package:eng_activator_app/state/activity_response_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localStorageKey = 'eng_activator_auth_data';

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

  void setAuthData(AuthResponse authResponse) {
    _token = authResponse.token;
    _user = authResponse.user;
    _tokenExpirationDate = authResponse.tokenExpirationDate;
    _autoLogout();
    _saveAuthDataInLocalStorage();

    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    Provider.of<ActivityResponseProvider>(context, listen: false).resetState();
    Provider.of<ActivityProvider>(context, listen: false).resetState();
    removeAuthData();
  }

  void removeAuthData() {
    _token = '';
    _tokenExpirationDate = null;
    _user = null;
    _autoLogoutTimer?.cancel();
    _autoLogoutTimer = null;
    _removeAuthDataFromLocalStorage();

    notifyListeners();
  }

  void _autoLogout() {
    _autoLogoutTimer?.cancel();

    var secondsUntilExpiration = _tokenExpirationDate?.difference(DateTime.now().subtract(Duration(days: 1))).inSeconds;

    if (secondsUntilExpiration != null) {
      _autoLogoutTimer = Timer(Duration(seconds: secondsUntilExpiration), removeAuthData);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_localStorageKey)) {
      return false;
    }

    var isLoggedIn = false;

    Map<String, dynamic> json = jsonDecode(prefs.getString(_localStorageKey) as String);
    var authData = AuthResponse.fromJson(json);

    if ((authData.tokenExpirationDate as DateTime).isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      _token = authData.token;
      _user = authData.user;
      _tokenExpirationDate = authData.tokenExpirationDate;
      _autoLogout();
      isLoggedIn = true;
      notifyListeners();
    }

    return isLoggedIn;
  }

  void _saveAuthDataInLocalStorage() {
    SharedPreferences.getInstance().then((value) {
      var authData = {
        "token": _token,
        "tokenExpirationDate": _tokenExpirationDate.toString(),
        "user": {
          "id": _user?.id,
          "name": _user?.name,
        }
      };
      value.setString(_localStorageKey, jsonEncode(authData));
    }).catchError((e) {});
  }

  void _removeAuthDataFromLocalStorage() {
    SharedPreferences.getInstance().then((value) {
      value.remove(_localStorageKey);
    }).catchError((e) {});
  }
}
