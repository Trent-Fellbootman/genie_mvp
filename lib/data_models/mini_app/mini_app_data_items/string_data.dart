import 'package:flutter/foundation.dart';
import '../../data_tree_convertible.dart';

class StringData extends ChangeNotifier {
  StringData({String? data}) : _data = data ?? "";

  String _data;

  String get data => _data;

  set data(String value) {
    _data = value;
    notifyListeners();
  }

  @override
  String toString() => 'StringData($_data)';

  dynamic serializeDataToDataTree() => data;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StringData && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
