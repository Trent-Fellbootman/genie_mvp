import 'package:flutter/foundation.dart';

class IntegerData extends ChangeNotifier {
  IntegerData({required int value}) : _value = value;

  int _value;

  int get value => _value;

  set value(int value) {
    _value = value;
    notifyListeners();
  }
}