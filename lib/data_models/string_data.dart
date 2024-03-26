import 'package:flutter/foundation.dart';

class StringData extends ChangeNotifier {
  StringData({value}) : _value = value;

  String _value;

  String get data => _value;

  set data(String value) {
    _value = value;
    notifyListeners();
  }
}
