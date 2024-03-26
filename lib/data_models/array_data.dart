import 'package:flutter/foundation.dart';

import 'data_item.dart';

/// An array of data items with the same type.
class ArrayData extends ChangeNotifier {
  ArrayData({List<DataItem>? list, required this.itemType}) : _list = list ?? <DataItem>[];
  final List<DataItem> _list;
  final DataItemType itemType;

  DataItem? getValue(int index) {
    if (index < 0 || index >= _list.length) {
      return null;
    }
    return _list[index];
  }

  DataItem? remove(int index) {
    if (index < 0 || index >= _list.length) {
      return null;
    }
    DataItem item = _list.removeAt(index);
    notifyListeners();
    return item;
  }

  void insert(int index, DataItem item) {
    if (item.dataItemType != itemType) {
      throw Exception("Attempting to insert an item of type ${item.dataItemType} into an array of type $itemType");
    }

    if (index < 0 || index > _list.length) {
      return;
    }

    _list.insert(index, item);
    notifyListeners();
  }

  int get length => _list.length;

  @override
  String toString() => _list.toString();
}
