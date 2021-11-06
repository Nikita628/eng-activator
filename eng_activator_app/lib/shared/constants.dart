import 'package:flutter/cupertino.dart';

class AppColors {
  static const int green = 0xff12c0a0;
  static const int yellow = 0xfffbe37a;
  static const int black = 0xff3b3b3b;
  static const int grey = 0xff9f9f9f;
}

class AppConstants {
  static const double preferredAppBarHeight = 50;
  static const String apiUrl = '10.0.2.2:5001';
  static const Map<String, String> apiHeaders = {
    "content-type": "application/json",
  };
  static const hasReviewedSomeoneKey = 'hasReviewedSomeone';
}

class ContextAccess {
  static late BuildContext context;
}