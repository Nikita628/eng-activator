import 'package:eng_activator_app/models/activity/activity.dart';

class ActivityHistory {
  static const int _maxHistorySize = 2;
  List<Activity> _history = [];
  int _currentHistoryIndex = 0;

  bool canMoveBack() {
    return _currentHistoryIndex > 0;
  }

  bool canMoveForward() {
    return _currentHistoryIndex < _history.length - 1;
  }

  void push(Activity activity) {
    if (_history.length < _maxHistorySize) {
      _history.add(activity);
    } else {
      for (var i = 0; i < _history.length - 1; i++) {
        _history[i] = _history[i + 1];
      }

      _history[_history.length - 1] = activity;
    }

    _currentHistoryIndex = _history.length - 1;
  }

  Activity moveBack() {
    _currentHistoryIndex--;

    return _history[_currentHistoryIndex];
  }

  Activity moveForward() {
    _currentHistoryIndex++;

    return _history[_currentHistoryIndex];
  }

  Activity? getCurrent() {
    if (_history.isEmpty) {
      return null;
    }

    return _history[_currentHistoryIndex];
  }

  void clear() {
    _currentHistoryIndex = 0;
    _history.clear();
  }
}