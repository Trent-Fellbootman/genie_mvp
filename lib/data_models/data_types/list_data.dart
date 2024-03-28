import 'package:flutter/foundation.dart';

/// An array of data items with the same type.
class ListData<ItemType> extends ChangeNotifier {
  ListData({List<ItemType>? list}) : _data = list ?? <ItemType>[];

  List<ItemType> _data;

  List<ItemType> get data => _data;

  set list(List<ItemType> data) {
    _data = data;
    notifyListeners();
  }

  ItemType? getValue(int index) {
    if (index < 0 || index >= _data.length) {
      return null;
    }
    return _data[index];
  }

  ItemType? remove(int index) {
    if (index < 0 || index >= _data.length) {
      return null;
    }
    ItemType item = _data.removeAt(index);
    notifyListeners();
    return item;
  }

  void insert(int index, ItemType item) {
    if (index < 0 || index > _data.length) {
      return;
    }

    _data.insert(index, item);
    notifyListeners();
  }

  int get length => _data.length;

  @override
  String toString() => _data.toString();
}
