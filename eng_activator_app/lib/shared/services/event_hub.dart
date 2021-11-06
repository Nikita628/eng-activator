class EventHub {
  final List<Map<String, Function>> _subscriptions = [];

  void addOrReplaceListener(String event, Function handler) {
    var existingSubscriptionIndex = _subscriptions.indexWhere((element) => element.keys.first == event);

    if (existingSubscriptionIndex == -1) {
      _subscriptions.add({ event: handler });
    } else {
      _subscriptions[existingSubscriptionIndex] = { event: handler };
    }
  }

  void notifyListeners(String event) {
    for (var s in _subscriptions) {
      if (s.keys.first == event) {
        var handler = s[event] as Function;
        handler();
      }
    }
  }

  // void removeListener(String event) {
  //   _subscriptions.removeWhere((element) => element.keys.first == event);
  // }
}