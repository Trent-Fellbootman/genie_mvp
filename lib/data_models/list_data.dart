import 'package:flutter/foundation.dart';

import 'data_item.dart';

class ListData extends ChangeNotifier {
  final List<DataItem> _list = [];

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
    if (index < 0 || index > _list.length) {
      return;
    }

    _list.insert(index, item);
    notifyListeners();
  }

  int get length => _list.length;
}
