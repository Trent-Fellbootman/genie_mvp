import 'package:flutter/foundation.dart';

import 'data_item.dart';

class NamedTupleData extends ChangeNotifier {
  NamedTupleData({required elementTypeConfig, required elements}) : _elementTypeConfig = elementTypeConfig, _elements = elements;

  final Map<String, DataItemType> _elementTypeConfig;
  final Map<String, DataItem> _elements;

  Map<String, DataItemType> get elementTypeConfig => _elementTypeConfig;
  Map<String, DataItem> get elements => _elements;

  @override
  String toString() {
    List<String> elementStrings = [
      for (var element in _elements.entries)
        "${element.key}: ${element.value},\n"
    ];

    return "NamedTuple{\n${elementStrings.join()}}";
  }

  dynamic serializeDataToDataTree() {
    return _elements
        .map((key, value) => MapEntry(key, value.serializeDataToDataTree()));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NamedTupleData &&
        mapEquals(other._elementTypeConfig, _elementTypeConfig) &&
        mapEquals(other._elements, _elements);
  }

  @override
  int get hashCode => _elementTypeConfig.hashCode ^ _elements.hashCode;
}

class NamedTupleAuxiliaryTypeData {
  NamedTupleAuxiliaryTypeData({required this.elementTypeConfig});

  final Map<String, DataItemType> elementTypeConfig;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NamedTupleAuxiliaryTypeData &&
        mapEquals(other.elementTypeConfig, elementTypeConfig);
  }

  @override
  int get hashCode => elementTypeConfig.hashCode;
}
