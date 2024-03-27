import 'package:flutter/foundation.dart';
import 'named_tuple.dart';

import 'string_data.dart';
import 'array_data.dart';

enum BasicDataItemType { string, array, namedTuple }

// TODO: unit tests
class DataItemType {
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
}

class DataItem extends ChangeNotifier {
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
}
