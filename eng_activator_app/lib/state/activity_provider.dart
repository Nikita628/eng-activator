import 'package:eng_activator_app/models/activity/activity.dart';
import 'package:eng_activator_app/services/activity/activity_history.dart';
import 'package:eng_activator_app/shared/services/injector.dart';
import 'package:eng_activator_app/shared/services/storage.dart';
import 'package:eng_activator_app/shared/state_management/state_piece.dart';
import 'package:flutter/material.dart';

class ActivityProvider with ChangeNotifier {
  final AppStorage _appStorage = Injector.get<AppStorage>();
  final ActivityHistory activityHistory = ActivityHistory();
  bool generateNewActivityOnInitialization = false;
  Observable<String> currentActivityAnswer = Observable('');

  Activity? getCurrentActivity() {
    return activityHistory.getCurrent();
  }

  void setCurrentActivity(Activity activity) {
    currentActivityAnswer.set('');
    activityHistory.push(activity);
  }

  void setRandomPictureActivity() {
    setCurrentActivity(_appStorage.getRandomPictureActivity());
  }

  void setRandomQuestionActivity() {
    setCurrentActivity(_appStorage.getRandomQuestionActivity());
  }

  void resetState() {
    currentActivityAnswer.set('');
    activityHistory.clear();
  }

  void notifyListenersAboutChange() {
    notifyListeners();
  }
}
