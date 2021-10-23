import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/storage.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final AppStorage _appStorage = Injector.get<AppStorage>();
  Activity? _currentActivity;
  String _currentActivityAnswer = '';

  Activity? getCurrentActivity() {
    return _currentActivity;
  }

  void setCurrentActivity(Activity? activity) {
    _currentActivityAnswer = '';
    _currentActivity = activity;

    notifyListeners();
  }

  void setRandomPictureActivity() {
    setCurrentActivity(_appStorage.getRandomPictureActivity());
  }

  void setRandomQuestionActivity() {
    setCurrentActivity(_appStorage.getRandomQuestionActivity());
  }

  String getCurrentActivityAnswer() {
    return _currentActivityAnswer;
  }

  void setCurrentActivityAnswer(String answer) {
    _currentActivityAnswer = answer;

    notifyListeners();
  }
}
