class EventHub {
  final List<Map<String, Function>> _subscriptions = [];

  void subscribe(String event, Function observer) {
    _subscriptions.add({ event: observer });
  }

  void notifyObservers(String event) {
    for (var s in _subscriptions) {
      if (s.entries.first.key == event) {
        var handler = s.entries.first.value;
        handler();
      }
    }
  }

  void unsubscribe(Function observer) {
    _subscriptions.removeWhere((element) => element.entries.first.value == observer);
  }
}

class AppEvents {
  static const String ScrollPageUp = "ScrollPageUp";
  static const String ScrollPageDown = "ScrollPageDown";
}