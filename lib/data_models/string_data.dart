import 'package:flutter/foundation.dart';

class StringData extends ChangeNotifier {
  StringData({String? data}) : _value = data ?? "";

  String _value;

  String get data => _value;

  set data(String value) {
    _value = value;
    notifyListeners();
  }

  @override
  String toString() => 'StringData($_value)';
}
