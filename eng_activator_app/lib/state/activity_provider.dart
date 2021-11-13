import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/services/activity/activity_history.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/storage.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final AppStorage _appStorage = Injector.get<AppStorage>();
  final ActivityHistory activityHistory = ActivityHistory();
  String _currentActivityAnswer = '';
  bool generateNewActivityOnInitialization = false;

  Activity? getCurrentActivity() {
    return activityHistory.getCurrent();
  }

  void setCurrentActivity(Activity activity) {
    _currentActivityAnswer = '';
    activityHistory.push(activity);
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
  }

  void resetState() {
    _currentActivityAnswer = '';
    activityHistory.clear();
  }

  void notifyListenersAboutChange() {
    notifyListeners();
  }
}
