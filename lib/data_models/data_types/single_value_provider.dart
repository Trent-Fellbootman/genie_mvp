import 'package:flutter/foundation.dart';

class SingleValueProvider<T> extends ChangeNotifier {
  SingleValueProvider({required T value}) : _value = value;

  T _value;

  T get value => _value;

  set value(T value) {
    _value = value;
    notifyListeners();
  }
}