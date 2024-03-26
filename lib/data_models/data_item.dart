import 'package:flutter/foundation.dart';

import 'string_data.dart';
import 'array_data.dart';

enum BasicDataItemType { string, array }

class ArrayAuxiliaryTypeData {
  ArrayAuxiliaryTypeData({required this.itemType});

  final DataItemType itemType;
}

// TODO: unit tests
class DataItemType {
  DataItemType({required this.basicDataItemType, this.arrayAuxiliaryTypeData});

  final BasicDataItemType basicDataItemType;
  final ArrayAuxiliaryTypeData? arrayAuxiliaryTypeData;

  @override
  bool operator==(Object other) {
    if (identical(this, other)) return true;

    return other is DataItemType && other.basicDataItemType == basicDataItemType && other.arrayAuxiliaryTypeData == arrayAuxiliaryTypeData;
  }

  @override
  int get hashCode => basicDataItemType.hashCode ^ arrayAuxiliaryTypeData.hashCode;

  @override
  String toString() {
    return """DataItemType(
    basicDataItemType: $basicDataItemType,
    arrayAuxiliaryTypeData: $arrayAuxiliaryTypeData
)""";
  }
}

class DataItem extends ChangeNotifier {
  DataItem({required this.dataItemType, this.stringData, this.arrayData});

  final DataItemType dataItemType;
  final StringData? stringData;
  final ArrayData? arrayData;

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
    }
  }

  @override
  String toString() {
    switch (dataItemType.basicDataItemType) {
      case BasicDataItemType.string:
        return 'DataItem::String(${stringData!})';
      case BasicDataItemType.array:
        return 'DataItem::Array<${dataItemType.arrayAuxiliaryTypeData!.itemType}>(${arrayData!})';
    }
  }
}
