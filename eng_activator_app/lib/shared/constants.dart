import 'package:eng_activator_app/shared/enums.dart';

class AppColors {
  static const int green = 0xff12c0a0;
  static const int yellow = 0xfffbe37a;
  static const int black = 0xff3b3b3b;
  static const int grey = 0xff9f9f9f;
}

class AppConstants {
  static var currentAppEnvironment = AppEnvironment.Local;

  static const double preferredAppBarHeight = 50;

  static const String _localApiUrl = '10.0.2.2:5001';
  static const String _localApiUrlWithPrefix = 'http://10.0.2.2:5001';

  static const String _devApiUrl = 'exenge-001-site1.ftempurl.com';
  static const String _devApiUrlWithPrefix = 'http://exenge-001-site1.ftempurl.com';
  
  static const String _prodApiUrl = '';
  static const String _prodApiUrlWithPrefix = '';

  static const Map<String, String> apiHeaders = {
    "content-type": "application/json",
  };

  static String getApiUrl() {
    switch (currentAppEnvironment) {
      case AppEnvironment.Local:
        return _localApiUrl;
      case AppEnvironment.Development:
        return _devApiUrl;
      case AppEnvironment.Production:
        return _prodApiUrl;
      default:
        return '';
    }
  }

  static String getApiUrlWithPrefix() {
    switch (currentAppEnvironment) {
      case AppEnvironment.Local:
        return _localApiUrlWithPrefix;
      case AppEnvironment.Development:
        return _devApiUrlWithPrefix;
      case AppEnvironment.Production:
        return _prodApiUrlWithPrefix;
      default:
        return '';
    }
  }
}