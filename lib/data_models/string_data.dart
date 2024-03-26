import 'package:flutter/material.dart';

class StringData extends ChangeNotifier {
  StringData({value}) : _value = value;

  String _value;

  String get value => _value;

  set value(String value) {
    _value = value;
    notifyListeners();
  }
}
