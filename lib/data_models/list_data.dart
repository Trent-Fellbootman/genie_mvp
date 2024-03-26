import 'package:flutter/material.dart';

import 'data_item.dart';

class ListData extends ChangeNotifier {
  final List<DataItem> _list = [];

  DataItem? remove(int index) {
    if (index < 0 || index >= _list.length) {
      return null;
    }
    DataItem item = _list.removeAt(index);
    notifyListeners();
    return item;
  }

  void add(int index, DataItem item) {
    if (index < 0 || index > _list.length) {
      return;
    }

    _list.insert(index, item);
    notifyListeners();
  }
}
