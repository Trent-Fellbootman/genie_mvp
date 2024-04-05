import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'string_display_widget.dart';
import 'file_display_widget.dart';
import 'array_display_widget.dart';
import 'named_tuple_display_widget.dart';

class DataItemDisplayWidget extends StatelessWidget {
  const DataItemDisplayWidget({super.key, required this.dataItem});

  final DataItem dataItem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataItem,
      child: Consumer<DataItem>(
        builder: (context, dataItem, child) {
          switch (dataItem.dataItemType.basicDataItemType) {
            case BasicDataItemType.string:
              return StringDisplayWidget(
                  stringDataInstance: dataItem.stringData!);
            case BasicDataItemType.file:
              return FileDisplayWidget(fileDataInstance: dataItem.fileData!);
            case BasicDataItemType.array:
              return ArrayDisplayWidget(arrayDataInstance: dataItem.arrayData!);
            case BasicDataItemType.namedTuple:
              return NamedTupleDisplayWidget(
                  namedTupleDataInstance: dataItem.namedTupleData!);
          }
        },
      ),
    );
  }
}
