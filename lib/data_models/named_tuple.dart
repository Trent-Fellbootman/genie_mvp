import 'package:flutter/foundation.dart';
import 'data_item.dart';

class NamedTupleData extends ChangeNotifier {
  NamedTupleData({required this.elementTypeConfig, required this.elements});

  final Map<String, DataItemType> elementTypeConfig;
  final Map<String, DataItem> elements;

  @override
  String toString() {
    List<String> elementStrings = [
      for (var element in elements.entries)
        "${element.key}: ${element.value},\n"
    ];

    return "NamedTuple{\n${elementStrings.join()}}";
  }
}

class NamedTupleAuxiliaryTypeData {
  NamedTupleAuxiliaryTypeData({required this.elementTypeConfig});

  final Map<String, DataItemType> elementTypeConfig;
}