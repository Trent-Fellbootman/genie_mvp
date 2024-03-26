import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:genie_mvp/data_models/array_data.dart';
import 'package:genie_mvp/data_models/data_item.dart';
import 'data_item_input_widget.dart';

/// An array input widget is used for inputting a variable-sized array containing same type of data items.
class ArrayInputWidget extends StatelessWidget {
  const ArrayInputWidget(
      {super.key, required this.arrayDataInstance});

  final ArrayData arrayDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArrayData>.value(
      value: arrayDataInstance,
      child: Column(
        children: [
          Expanded(
            child: Consumer<ArrayData>(
              builder: (context, listData, child) {
                return ReorderableListView(
                  children: <Widget>[
                    for (int index = 0; index < listData.length; index += 1)
                      Row(
                        key: Key('$index'),
                        children: [
                          Expanded(
                            child: DataItemInputWidget(
                                dataItem: listData.getValue(index)!),
                          ),
                          const Icon(Icons.drag_handle),
                        ],
                      ),
                  ],
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }

                    var item = listData.remove(oldIndex)!;
                    listData.insert(newIndex, item);
                  },
                );
              },
            ),
          ),
          FilledButton(
              onPressed: () {
                arrayDataInstance.insert(arrayDataInstance.length,
                    DataItem.createDefaultDataItem(arrayDataInstance.itemType));
              },
              child: const Icon(Icons.add))
        ],
      ),
    );
  }
}
