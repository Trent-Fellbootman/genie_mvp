import 'package:flutter/foundation.dart';

import 'data_item.dart';
import '../../data_tree_convertible.dart';

class NamedTupleData extends ChangeNotifier
    implements DataTreeDeserializable, DataTreeSerializable {
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

  // static method override
  static NamedTupleData fromDataTree(dynamic dataTree) {
    assert(dataTree['type']['basic-type'] == 'named-tuple');
    Map<String, dynamic> elementsDataTree = dataTree['data'];

    Map<String, DataItem> elements = elementsDataTree
        .map((key, value) => MapEntry(key, DataItem.fromDataTree(value)));
    Map<String, DataItemType> elementTypeConfig =
        elements.map((key, value) => MapEntry(key, value.dataItemType));

    return NamedTupleData(
        elementTypeConfig: elementTypeConfig, elements: elements);
  }

  @override
  toDataTree() {
    return {
      'type': {
        'basic-type': 'named-tuple',
        'auxiliary-data': elementTypeConfig
            .map((key, value) => MapEntry(key, value.toDataTree())),
      },
      'data': elements.map((key, value) => MapEntry(key, value.toDataTree()))
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NamedTupleData && other.elementTypeConfig == elementTypeConfig && other.elements == elements;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => elementTypeConfig.hashCode ^ elements.hashCode;

}

class NamedTupleAuxiliaryTypeData {
  NamedTupleAuxiliaryTypeData({required this.elementTypeConfig});

  final Map<String, DataItemType> elementTypeConfig;
}
