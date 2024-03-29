import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/ui/data_input_widgets/named_tuple_input_widget.dart';
import 'package:provider/provider.dart';

import 'string_input_widget.dart';
import 'array_input_widget.dart';

class DataItemInputWidget extends StatelessWidget {
  const DataItemInputWidget({super.key, required this.dataItem});

  final DataItem dataItem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataItem,
      child: Consumer<DataItem>(
        builder: (context, dataItem, child) {
          switch (dataItem.dataItemType.basicDataItemType) {
            case BasicDataItemType.string:
              return StringInputWidget(
                  stringDataInstance: dataItem.stringData!);
            case BasicDataItemType.array:
              return ArrayInputWidget(arrayDataInstance: dataItem.arrayData!);
            case BasicDataItemType.namedTuple:
              return NamedTupleInputWidget(
                  namedTupleDataInstance: dataItem.namedTupleData!);
          }
        },
      ),
    );
  }
}
