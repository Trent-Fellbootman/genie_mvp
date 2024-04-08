import 'package:flutter/foundation.dart';

import 'string_data.dart';
import 'file_data.dart';
import 'array_data.dart';
import 'named_tuple.dart';

import '../../data_tree_convertible.dart';

enum BasicDataItemType { string, file, array, namedTuple }

// TODO: unit tests
/// ## Serialization Scheme Examples
///
/// ### String
///
/// {
///   "basic-type": "string"
/// }
///
/// ### File
///
/// {
///   "basic-type": "file"
/// }
///
/// ### Array
///
/// {
///   "basic-type": "array",
///   "auxiliary-data": {
///     "basic-type": string
///   }
/// }
///
/// ### Named Tuple
///
/// {
///   "basic-type": "named-tuple",
///   "auxiliary-data": {
///     "value 1": {
///       "basic-type": string
///     }
///   }
/// }
class DataItemType implements DataTreeSerializable, DataTreeDeserializable {
  DataItemType(
      {required this.basicDataItemType,
      this.arrayAuxiliaryTypeData,
      this.namedTupleAuxiliaryTypeData});

  final BasicDataItemType basicDataItemType;
  final ArrayAuxiliaryTypeData? arrayAuxiliaryTypeData;
  final NamedTupleAuxiliaryTypeData? namedTupleAuxiliaryTypeData;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // TODO: keep an eye on this
    return other is DataItemType &&
        other.basicDataItemType == basicDataItemType &&
        other.arrayAuxiliaryTypeData == arrayAuxiliaryTypeData &&
        other.namedTupleAuxiliaryTypeData == namedTupleAuxiliaryTypeData;
  }

  // TODO: keep an eye on this
  @override
  int get hashCode =>
      basicDataItemType.hashCode ^
      arrayAuxiliaryTypeData.hashCode ^
      namedTupleAuxiliaryTypeData.hashCode;

  @override
  String toString() {
    switch (basicDataItemType) {
      case BasicDataItemType.string:
        return 'DataItemType::string';
      case BasicDataItemType.file:
        return 'DataItemType::file';
      case BasicDataItemType.array:
        return 'DataItemType::array<${arrayAuxiliaryTypeData!.itemType}>';
      case BasicDataItemType.namedTuple:
        return 'DataItemType::namedTuple<${namedTupleAuxiliaryTypeData!.elementTypeConfig}>';
    }
  }

  /// Deserializes a data item from a data tree containing only the data of that item but not its type information.
  DataItem deserializeDataItem(dynamic dataTree) {
    switch (basicDataItemType) {
      case BasicDataItemType.string:
        return DataItem(
            dataItemType: this, stringData: StringData(data: dataTree));
      case BasicDataItemType.file:
        return DataItem(
            dataItemType: this, fileData: FileData(fileID: dataTree));
      case BasicDataItemType.array:
        DataItemType itemType = arrayAuxiliaryTypeData!.itemType;
        List<DataItem> items = (dataTree as List)
            .map((e) => itemType.deserializeDataItem(e))
            .toList();
        return DataItem(
            dataItemType: this,
            arrayData: ArrayData(itemType: itemType, data: items));
      case BasicDataItemType.namedTuple:
        Map<String, DataItemType> elementTypeConfig =
            namedTupleAuxiliaryTypeData!.elementTypeConfig;
        Map<String, DataItem> elements = (dataTree as Map<String, dynamic>).map(
            (key, value) => MapEntry(
                key, elementTypeConfig[key]!.deserializeDataItem(value)));
        return DataItem(
            dataItemType: this,
            namedTupleData: NamedTupleData(
                elementTypeConfig: elementTypeConfig, elements: elements));
    }
  }

  // static method override
  static DataItemType fromDataTree(dataTree) {
    assert(dataTree is Map<String, dynamic>);

    switch (dataTree["basic-type"]) {
      case "string":
        return DataItemType(basicDataItemType: BasicDataItemType.string);
      case "file":
        return DataItemType(basicDataItemType: BasicDataItemType.file);
      case "array":
        return DataItemType(
          basicDataItemType: BasicDataItemType.array,
          arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
            itemType: fromDataTree(dataTree["auxiliary-data"]),
          ),
        );
      case "named-tuple":
        Map<String, dynamic> auxiliaryDataTree = dataTree["auxiliary-data"];
        return DataItemType(
          basicDataItemType: BasicDataItemType.namedTuple,
          namedTupleAuxiliaryTypeData: NamedTupleAuxiliaryTypeData(
            elementTypeConfig: auxiliaryDataTree
                .map((key, value) => MapEntry(key, fromDataTree(value))),
          ),
        );
      default:
        throw Exception("Invalid data tree: $dataTree");
    }
  }

  @override
  toDataTree() {
    switch (basicDataItemType) {
      case BasicDataItemType.string:
        return {
          "basic-type": "string",
        };
      case BasicDataItemType.file:
        return {
          "basic-type": "file",
        };
      case BasicDataItemType.array:
        return {
          "basic-type": "array",
          "auxiliary-data": arrayAuxiliaryTypeData!.itemType.toDataTree(),
        };
      case BasicDataItemType.namedTuple:
        return {
          "basic-type": "named-tuple",
          "auxiliary-data": namedTupleAuxiliaryTypeData!.elementTypeConfig
              .map((key, value) => MapEntry(key, value.toDataTree())),
        };
    }
  }
}

/// ## Serialization Examples (no type information)
///
/// ### String
///
/// "data"
///
/// ### file
///
/// "file.pdf"
///
/// ### Array
///
/// ["data"]
///
/// ### Named Tuple
///
/// {
///   "test": "data"
/// }
class DataItem extends ChangeNotifier
    implements DataTreeSerializable, DataTreeDeserializable {
  DataItem(
      {required this.dataItemType,
      this.stringData,
      this.fileData,
      this.arrayData,
      this.namedTupleData});

  final DataItemType dataItemType;
  final StringData? stringData;
  final FileData? fileData;
  final ArrayData? arrayData;
  final NamedTupleData? namedTupleData;

  static DataItem createDefaultDataItem(DataItemType dataItemType) {
    switch (dataItemType.basicDataItemType) {
      case BasicDataItemType.string:
        return DataItem(dataItemType: dataItemType, stringData: StringData());
      case BasicDataItemType.array:
        return DataItem(
          dataItemType: dataItemType,
          arrayData: ArrayData(
            itemType: dataItemType.arrayAuxiliaryTypeData!.itemType,
          ),
        );
      case BasicDataItemType.file:
        return DataItem(dataItemType: dataItemType, fileData: FileData());
      case BasicDataItemType.namedTuple:
        return DataItem(
          dataItemType: dataItemType,
          namedTupleData: NamedTupleData(
            elementTypeConfig:
                dataItemType.namedTupleAuxiliaryTypeData!.elementTypeConfig,
            elements: dataItemType
                .namedTupleAuxiliaryTypeData!.elementTypeConfig
                .map((key, value) =>
                    MapEntry(key, DataItem.createDefaultDataItem(value))),
          ),
        );
    }
  }

  @override
  String toString() {
    switch (dataItemType.basicDataItemType) {
      case BasicDataItemType.string:
        return 'DataItem::String(${stringData!})';
      case BasicDataItemType.file:
        return 'DataItem::File(${fileData!})';
      case BasicDataItemType.array:
        return 'DataItem::Array<${arrayData!.itemType}>(${arrayData!})';
      case BasicDataItemType.namedTuple:
        return 'DataItem::NamedTuple<${namedTupleData!.elementTypeConfig}>(${namedTupleData!})';
    }
  }

  /// Serializes the data item to a data tree.
  ///
  /// The type information is not serialized.
  dynamic serializeDataToDataTree() {
    switch (dataItemType.basicDataItemType) {
      case BasicDataItemType.string:
        return stringData!.serializeDataToDataTree();
      case BasicDataItemType.file:
        return fileData!.serializeDataToDataTree();
      case BasicDataItemType.array:
        return arrayData!.serializeDataToDataTree();
      case BasicDataItemType.namedTuple:
        return namedTupleData!.serializeDataToDataTree();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DataItem &&
        other.dataItemType == dataItemType &&
        other.stringData == stringData &&
        other.arrayData == arrayData &&
        other.namedTupleData == namedTupleData;
  }

  @override
  int get hashCode =>
      dataItemType.hashCode ^
      stringData.hashCode ^
      arrayData.hashCode ^
      namedTupleData.hashCode;

  @override
  dynamic toDataTree() {
    return {
      "type": dataItemType.toDataTree(),
      "data": serializeDataToDataTree(),
    };
  }

  // static method override
  static DataItem fromDataTree(dynamic dataTree) {
    assert(dataTree is Map<String, dynamic>);
    DataItemType dataItemType = DataItemType.fromDataTree(dataTree['type']);
    return dataItemType.deserializeDataItem(dataTree['data']);
  }

  /// Sets all file IDs to null.
  void invalidateAllFileIDs() {
    switch (dataItemType.basicDataItemType) {
      case BasicDataItemType.string:
        break;
      case BasicDataItemType.file:
        fileData!.invalidateFileID();
        break;
      case BasicDataItemType.array:
        for (int i = 0; i < arrayData!.length; i++) {
          arrayData!.getValue(i)!.invalidateAllFileIDs();
        }
        break;
      case BasicDataItemType.namedTuple:
        for (DataItem element in namedTupleData!.elements.values) {
          element.invalidateAllFileIDs();
        }
        break;
    }
  }
}
