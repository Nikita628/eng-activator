import 'package:eng_activator_app/shared/services/data.dart';

class ActivityValidator {
  String? validateRequiredAndSwearing(String? answer) {
    String? error;

    if (answer == null || answer.isEmpty) {
      error = 'Required';
    } else if (_containsSwearing(answer)) {
      error = 'Contains swearing or forbidden language';
    }

    return error;
  }

  bool _containsSwearing(String val) {
    bool contains = false;

    for (var swearing in AppData.swearWords) {
      if (val.contains(swearing)) {
        contains = true;
        break;
      }
    }

    return contains;
  }
}