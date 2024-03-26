import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:genie_mvp/data_models/list_data.dart';
import 'package:genie_mvp/data_models/data_item.dart';
import 'data_item_input_widget.dart';

class ListInputWidget extends StatelessWidget {
  const ListInputWidget({super.key, required this.listDataInstance});

  final ListData listDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListData>.value(
      value: listDataInstance,
      child: Consumer<ListData>(
        builder: (context, listData, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              DataItem? dataItem = listData.getValue(index);
              if (dataItem == null) {
                return null;
              } else {
                return DataItemInputWidget(dataItem: dataItem);
              }
            },
          );
        },
      ),
    );
  }
}
