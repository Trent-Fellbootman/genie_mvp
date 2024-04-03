import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'data_item_input_widget.dart';

/// An array input widget is used for inputting a variable-sized array containing same type of data items.
class ArrayInputWidget extends StatelessWidget {
  const ArrayInputWidget({super.key, required this.arrayDataInstance});

  final ArrayData arrayDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArrayData>.value(
      value: arrayDataInstance,
      child: Consumer<ArrayData>(
        builder: (context, listData, child) {
          return Card(
            elevation: 4,
            child: ExpansionTile(title: const Text("点击展开/收回列表"), children: [
              ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: listData.length, // Number of items in the list
                itemBuilder: (context, index) {
                  // Builds each item
                  DataItem dataItem = listData.getValue(index)!;
                  return Row(key: ObjectKey(dataItem), children: [
                    const Icon(Icons.drag_handle),
                    Expanded(
                        child: DataItemInputWidget(dataItem: dataItem),
                    ),
                    IconButton(
                      onPressed: () {
                        listData.remove(index);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ]);
                },
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1; // Adjust for removing the item
                  }

                  // Perform the reorder operation
                  var item = listData.remove(oldIndex)!;
                  listData.insert(newIndex, item);
                },
              ),
              FilledButton(
                onPressed: () {
                  arrayDataInstance.insert(arrayDataInstance.length,
                      DataItem.createDefaultDataItem(arrayDataInstance.itemType));
                },
                child: const Icon(Icons.add),
              )
            ]),
          );
        },
      ),
    );
  }
}
