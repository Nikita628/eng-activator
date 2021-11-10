class AppColors {
  static const int green = 0xff12c0a0;
  static const int yellow = 0xfffbe37a;
  static const int black = 0xff3b3b3b;
  static const int grey = 0xff9f9f9f;
}

class AppConstants {
  static bool isLocalDev = true;

  static const double preferredAppBarHeight = 50;

  static const String _localApiUrl = '10.0.2.2:5001';
  static const String _localApiUrlWithPrefix = 'https://10.0.2.2:5001';
  static const String _prodApiUrl = 'exenge-001-site1.ftempurl.com';
  static const String _prodApiUrlWithPrefix = 'http://exenge-001-site1.ftempurl.com';

  static const Map<String, String> apiHeaders = {
    "content-type": "application/json",
  };

  static String getApiUrl() {
    if (isLocalDev) {
      return _localApiUrl;
    } else {
      return _prodApiUrl;
    }
  }

  static String getApiUrlWithPrefix() {
    if (isLocalDev) {
      return _localApiUrlWithPrefix;
    } else {
      return _prodApiUrlWithPrefix;
    }
  }
}