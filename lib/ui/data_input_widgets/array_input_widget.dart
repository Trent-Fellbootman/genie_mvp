import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:genie_mvp/data_models/array_data.dart';
import 'package:genie_mvp/data_models/data_item.dart';
import 'data_item_input_widget.dart';

/// An array input widget is used for inputting a variable-sized array containing same type of data items.
class ArrayInputWidget extends StatelessWidget {
  const ArrayInputWidget({super.key, required this.arrayDataInstance});

  final ArrayData arrayDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArrayData>.value(
      value: arrayDataInstance,
      child: Column(
        children: [
          Consumer<ArrayData>(
            builder: (context, listData, child) {
              return ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: listData.length, // Number of items in the list
                itemBuilder: (context, index) {
                  // Builds each item
                  DataItem dataItem = listData.getValue(index)!;
                  return Row(key: ValueKey(dataItem), children: [
                    const Icon(Icons.drag_handle),
                    Expanded(
                        child: ExpansionTile(
                            title: Text("Item $index"),
                            children: [
                          Card(
                            elevation: 4,
                            child: DataItemInputWidget(dataItem: dataItem),
                          )
                        ])),
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
              );
            },
          ),
          FilledButton(
            onPressed: () {
              arrayDataInstance.insert(arrayDataInstance.length,
                  DataItem.createDefaultDataItem(arrayDataInstance.itemType));
            },
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
