import 'package:flutter/foundation.dart';

class StringData extends ChangeNotifier {
  StringData({required String value}) : _value = value;

  String _value;

  String get value => _value;

  set value(String value) {
    _value = value;
    notifyListeners();
  }
}