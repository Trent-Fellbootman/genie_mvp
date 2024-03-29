import 'package:flutter/foundation.dart';
import '../../data_tree_convertible.dart';

class StringData extends ChangeNotifier implements DataTreeDeserializable, DataTreeSerializable {
  StringData({String? data}) : _data = data ?? "";

  String _data;

  String get data => _data;

  set data(String value) {
    _data = value;
    notifyListeners();
  }

  @override
  String toString() => 'StringData($_data)';

  // static method override
  static StringData fromDataTree(dynamic dataTree) {
    assert(dataTree is Map<String, dynamic>);
    assert(dataTree['type']['basic-type'] == 'string');
    assert(dataTree['data'] is String);

    return StringData(data: dataTree['data'].toString());
  }

  @override
  String toDataTree() {
    return _data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StringData && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
