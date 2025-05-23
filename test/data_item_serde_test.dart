import 'package:test/test.dart';
import 'dart:convert';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/named_tuple.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/string_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/file_data.dart';

void main() {
  group(
      "Test serialization & deserialization of data item and data item type declaration",
      () {
    // sample objects
    DataItemType stringType =
        DataItemType(basicDataItemType: BasicDataItemType.string);
    DataItemType fileType =
        DataItemType(basicDataItemType: BasicDataItemType.file);
    DataItemType stringArrayType = DataItemType(
        basicDataItemType: BasicDataItemType.array,
        arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(itemType: stringType));
    DataItemType fileAndStringArrayNamedTupleType = DataItemType(
        basicDataItemType: BasicDataItemType.namedTuple,
        namedTupleAuxiliaryTypeData: NamedTupleAuxiliaryTypeData(
            elementTypeConfig: {
              "value 1": fileType,
              "value 2": stringArrayType
            }));
    DataItemType tupleArrayType = DataItemType(
        basicDataItemType: BasicDataItemType.array,
        arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
            itemType: fileAndStringArrayNamedTupleType));
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
                itemType: fileAndStringArrayNamedTupleType,
                data: [
                  DataItem(
                      dataItemType: fileAndStringArrayNamedTupleType,
                      namedTupleData: NamedTupleData(elementTypeConfig: {
                        "value 1": fileType,
                        "value 2": stringArrayType,
                      }, elements: {
                        "value 1": DataItem(
                          dataItemType: fileType,
                          fileData: FileData(fileID: "test-id"),
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
              dataItemType: stringType, stringData: StringData(data: "world"))
        }));

    test(
        "sample data item type declaration should be serialized to JSON and deserialized back.",
        () {
      String json = jsonEncode(topLevelNamedTupleType.toDataTree());
      DataItemType deserializedDataItemType =
          DataItemType.fromDataTree(jsonDecode(json));
      expect(topLevelNamedTupleType, deserializedDataItemType);
    });

    test(
        "The data part of the sample data item should be serialized to JSON and deserialized back.",
        () {
      String json = jsonEncode(sampleDataItem.serializeDataToDataTree());
      DataItem deserializedDataItem =
          topLevelNamedTupleType.deserializeDataItem(jsonDecode(json));
      expect(sampleDataItem, deserializedDataItem);
    });

    test("Sample data item should be serialized to JSON and deserialized back.",
        () {
      String json = jsonEncode(sampleDataItem.toDataTree());
      DataItem deserializedDataItem = DataItem.fromDataTree(jsonDecode(json));
      expect(sampleDataItem, deserializedDataItem);
    });
  });
}
