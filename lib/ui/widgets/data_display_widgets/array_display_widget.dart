import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'data_item_display_widget.dart';

/// An array input widget is used for inputting a variable-sized array containing same type of data items.
class ArrayDisplayWidget extends StatelessWidget {
  const ArrayDisplayWidget({super.key, required this.arrayDataInstance});

  final ArrayData arrayDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArrayData>.value(
      value: arrayDataInstance,
      child: Consumer<ArrayData>(
        builder: (context, arrayData, child) {
          return Card(
            elevation: 4,
            child: ExpansionTile(title: const Text("点击展开/收回列表"), children: [
              for (int index = 0; index < arrayData.length; index++)
                DataItemDisplayWidget(dataItem: arrayData.getValue(index)!)
            ]),
          );
        },
      ),
    );
  }
}
