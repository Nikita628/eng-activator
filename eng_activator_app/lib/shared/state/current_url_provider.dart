import 'package:eng_activator_app/widgets/screens/activity/picture_activity_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity/question_activity_screen.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/picture_activity_response.dart';
import 'package:eng_activator_app/widgets/screens/activity_response/question_activity_response.dart';
import 'package:eng_activator_app/widgets/screens/main_screen.dart';
import 'package:flutter/material.dart';

class CurrentUrlProvider with ChangeNotifier {
  String _currentUrl = '';

  String getCurrentUrl() {
    return _currentUrl;
  }

  void setCurrentUrlAndNotifyListeners(String currentUrl) {
    _currentUrl = currentUrl;

    notifyListeners();
  }

  void resetState() {
    _currentUrl = '';
  }

  bool isBackButtonShown() {
    return isOnActivityResponseScreen() || isOnActivityScreen();
  }

  bool isDictionaryButtonShown() {
    return _currentUrl != MainScreenWidget.screenUrl && _currentUrl.isNotEmpty;
  }

  bool isCurrentActivityButtonShown() {
    return _currentUrl != PictureActivityScreen.screenUrl && _currentUrl != QuestionActivityScreen.screenUrl;
  }

  bool isOnActivityScreen() {
    return _currentUrl == PictureActivityScreen.screenUrl || _currentUrl == QuestionActivityScreen.screenUrl;
  }

  bool isOnActivityResponseScreen() {
    return _currentUrl == PictureActivityResponseWidget.screenUrl || _currentUrl == QuestionActivityResponseWidget.screenUrl;
  }
}
