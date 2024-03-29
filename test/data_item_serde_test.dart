import 'package:test/test.dart';
import 'dart:convert';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/named_tuple.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/string_data.dart';

void main() {
  test("Sample data item should be serialized to JSON and deserialized back.",
      () {
    DataItemType stringType =
        DataItemType(basicDataItemType: BasicDataItemType.string);
    DataItemType stringArrayType = DataItemType(
        basicDataItemType: BasicDataItemType.array,
        arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(itemType: stringType));
    DataItemType stringAndStringArrayNamedTupleType = DataItemType(
        basicDataItemType: BasicDataItemType.namedTuple,
        namedTupleAuxiliaryTypeData: NamedTupleAuxiliaryTypeData(
            elementTypeConfig: {
              "value 1": stringType,
              "value 2": stringArrayType
            }));
    DataItemType tupleArrayType = DataItemType(
        basicDataItemType: BasicDataItemType.array,
        arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
            itemType: stringAndStringArrayNamedTupleType));
    DataItemType topLevelNamedTupleType = DataItemType(
        basicDataItemType: BasicDataItemType.namedTuple,
        namedTupleAuxiliaryTypeData:
            NamedTupleAuxiliaryTypeData(elementTypeConfig: {
          "value 1": tupleArrayType,
          "value 2": stringType,
        }));
    DataItem sampleDataItem = DataItem(
        dataItemType: topLevelNamedTupleType,
        namedTupleData: NamedTupleData(elementTypeConfig: {
          "value 1": tupleArrayType,
          "value 2": stringType,
        }, elements: {
          "value 1": DataItem(
              dataItemType: tupleArrayType,
              arrayData: ArrayData(
                itemType: stringAndStringArrayNamedTupleType,
                data: [
                  DataItem(
                      dataItemType: stringAndStringArrayNamedTupleType,
                      namedTupleData: NamedTupleData(elementTypeConfig: {
                        "value 1": stringType,
                        "value 2": stringArrayType,
                      }, elements: {
                        "value 1": DataItem(
                          dataItemType: stringType,
                          stringData: StringData(data: "hello"),
                        ),
                        "value 2": DataItem(
                            dataItemType: stringArrayType,
                            arrayData: ArrayData(
                              itemType: stringType,
                              data: [],
                            ))
                      }))
                ],
              )),
          "value 2": DataItem(
              dataItemType:
                  stringType,
              stringData: StringData(data: "world"))
        }));

    String json = jsonEncode(sampleDataItem.toDataTree());
    DataItem deserializedDataItem = DataItem.fromDataTree(jsonDecode(json));
    expect(sampleDataItem, deserializedDataItem);
  });
}
