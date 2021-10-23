class EventHub {
  final List<Map<String, Function>> _subscriptions = [];

  void subscribe(String event, Function handler) {
    _subscriptions.add({ event: handler });
  }

  void notify(String event) {
    for (var s in _subscriptions) {
      if (s.keys.first == event) {
        var handler = s[event] as Function;
        handler();
      }
    }
  }
}