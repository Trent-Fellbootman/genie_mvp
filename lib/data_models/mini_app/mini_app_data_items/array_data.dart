import 'package:flutter/foundation.dart';

import 'data_item.dart';

/// An array of data items with the same type.
class ArrayData extends ChangeNotifier {
  ArrayData({List<DataItem>? data, required this.itemType})
      : _array = data ?? <DataItem>[];
  final List<DataItem> _array;
  final DataItemType itemType;

  DataItem? getValue(int index) {
    if (index < 0 || index >= _array.length) {
      return null;
    }
    return _array[index];
  }

  DataItem? remove(int index) {
    if (index < 0 || index >= _array.length) {
      return null;
    }
    DataItem item = _array.removeAt(index);
    notifyListeners();
    return item;
  }

  void insert(int index, DataItem item) {
    if (item.dataItemType != itemType) {
      throw Exception(
          "Attempting to insert an item of type ${item.dataItemType} into an array of type $itemType");
    }

    if (index < 0 || index > _array.length) {
      return;
    }

    _array.insert(index, item);
    notifyListeners();
  }

  int get length => _array.length;

  @override
  String toString() => _array.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArrayData && other.itemType == itemType && listEquals(other._array, _array);
  }

  @override
  int get hashCode => itemType.hashCode ^ _array.hashCode;

  dynamic serializeDataToDataTree() {
    return _array.map((e) => e.serializeDataToDataTree()).toList();
  }
}

class ArrayAuxiliaryTypeData {
  ArrayAuxiliaryTypeData({required this.itemType});

  final DataItemType itemType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArrayAuxiliaryTypeData && other.itemType == itemType;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => itemType.hashCode;

}
