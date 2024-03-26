import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/data_item.dart';
import 'package:provider/provider.dart';

import 'string_input_widget.dart';
import 'list_input_widget.dart';

class DataItemInputWidget extends StatelessWidget {
  const DataItemInputWidget({super.key, required this.dataItem});

  final DataItem dataItem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dataItem,
      child: Consumer<DataItem>(
        builder: (context, dataItem, child) {
          switch (dataItem.dataItemType) {
            case DataItemType.string:
              return StringInputWidget(
                  stringDataInstance: dataItem.stringData!);
            case DataItemType.list:
              return ListInputWidget(listDataInstance: dataItem.listData!);
          }
        },
      ),
    );
  }
}
