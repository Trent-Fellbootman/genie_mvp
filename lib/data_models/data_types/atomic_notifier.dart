import 'package:flutter/foundation.dart';

class AtomicNotifier<ValueType> extends ChangeNotifier {
  AtomicNotifier({required ValueType value}) : _value = value;

  ValueType _value;

  ValueType get value => _value;

  set value(ValueType newValue) {
    _value = newValue;
    notifyListeners();
  }
}