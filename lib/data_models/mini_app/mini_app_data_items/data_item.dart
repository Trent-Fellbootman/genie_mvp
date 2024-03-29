import 'package:flutter/foundation.dart';

import 'named_tuple.dart';
import 'string_data.dart';
import 'array_data.dart';

import '../../data_tree_convertible.dart';

enum BasicDataItemType { string, array, namedTuple }

// TODO: unit tests
/// ## Serialization Scheme Examples
///
/// ### String
///
/// {
///   "basic-type": "string"
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

  @override
  int get hashCode =>
      basicDataItemType.hashCode ^ arrayAuxiliaryTypeData.hashCode;

  @override
  String toString() {
    switch (basicDataItemType) {
      case BasicDataItemType.string:
        return 'DataItemType::string';
      case BasicDataItemType.array:
        return 'DataItemType::array<${arrayAuxiliaryTypeData!.itemType}>';
      case BasicDataItemType.namedTuple:
        return 'DataItemType::namedTuple<${namedTupleAuxiliaryTypeData!.elementTypeConfig}>';
    }
  }

  // static method override
  static DataItemType fromDataTree(dataTree) {
    if (!dataTree is Map<String, dynamic>) {
      throw Exception("Invalid data tree: $dataTree");
    }

    switch (dataTree["basic-type"]) {
      case "string":
        return DataItemType(basicDataItemType: BasicDataItemType.string);
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

/// ## Serialization Examples
///
/// ### String
///
/// {
///   "type": {
///     "basic-type": "string"
///   },
///   "data": "hello world"
/// }
///
/// ### Array
///
/// {
///   "type": {
///     "basic-type": "array",
///     "auxiliary-data": {
///       "basic-type": "string"
///     }
///   },
///   "data": [
///     {
///       "type": {
///         "basic-type": "string"
///       },
///       "data": "hello"
///     },
///     {
///       "type": {
///         "basic-type": "string"
///       },
///       "data": "world"
///     },
///   ]
/// }
///
/// ### Named Tuple
///
/// {
///   "type": {
///     "basic-type": "named-tuple",
///     "auxiliary-data": {
///       "value 1": {
///         "basic-type": "string"
///       }
///     }
///   },
///   "data": {
///     "value 1": {
///       "type": {
///         "basic-type": "string"
///       },
///       "data": "hello world"
///     }
///   }
/// }
class DataItem extends ChangeNotifier
    implements DataTreeDeserializable, DataTreeSerializable {
  DataItem(
      {required this.dataItemType,
      this.stringData,
      this.arrayData,
      this.namedTupleData});

  final DataItemType dataItemType;
  final StringData? stringData;
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
      case BasicDataItemType.array:
        return 'DataItem::Array<${arrayData!.itemType}>(${arrayData!})';
      case BasicDataItemType.namedTuple:
        return 'DataItem::NamedTuple<${namedTupleData!.elementTypeConfig}>(${namedTupleData!})';
    }
  }

  // static method override
  static DataItem fromDataTree(dataTree) {
    if (!dataTree is Map<String, dynamic>) {
      throw Exception("Invalid data tree passed to `fromDataTree`: $dataTree");
    }

    switch (dataTree['type']['basic-type']) {
      case 'string':
        return DataItem(
            dataItemType:
                DataItemType(basicDataItemType: BasicDataItemType.string),
            stringData: StringData.fromDataTree(dataTree));
      case 'array':
        ArrayData arrayData = ArrayData.fromDataTree(dataTree);
        return DataItem(
          dataItemType: DataItemType(
            basicDataItemType: BasicDataItemType.array,
            arrayAuxiliaryTypeData:
                ArrayAuxiliaryTypeData(itemType: arrayData.itemType),
          ),
          arrayData: arrayData,
        );
      case 'named-tuple':
        NamedTupleData namedTupleData = NamedTupleData.fromDataTree(dataTree);
        return DataItem(
          dataItemType: DataItemType(
            basicDataItemType: BasicDataItemType.namedTuple,
            namedTupleAuxiliaryTypeData: NamedTupleAuxiliaryTypeData(
                elementTypeConfig: namedTupleData.elementTypeConfig),
          ),
          namedTupleData: namedTupleData,
        );
      default:
        throw Exception("Invalid data tree passed to `fromDataTree`: $dataTree");
    }
  }

  @override
  dynamic toDataTree() {
    // TODO: implement toDataTree
    throw UnimplementedError();
  }
}
