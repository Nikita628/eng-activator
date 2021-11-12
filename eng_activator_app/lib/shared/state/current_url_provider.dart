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
    return _currentUrl == QuestionActivityResponseWidget.screenUrl ||
        _currentUrl == PictureActivityResponseWidget.screenUrl;
  }

  bool isDictionaryButtonShown() {
    return _currentUrl != MainScreenWidget.screenUrl && _currentUrl.isNotEmpty;
  }
}
