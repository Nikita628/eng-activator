class StatePiece<T> {
  T _value;
  List<Function> _observers = [];

  StatePiece(T val) : _value = val;

  T get() {
    return _value;
  }

  void set(T val) {
    _value = val;
    _notifyObserversAboutChange();
  }

  void subscribe(Function(T) observer) {
    _observers.add(observer);
  }

  void unsubscribe(Function(T) observer) {
    _observers.remove(observer);
  }

  void _notifyObserversAboutChange() {
    for (var i = 0; i < _observers.length; i++) {
      _observers[i](_value);
    }
  }
}
