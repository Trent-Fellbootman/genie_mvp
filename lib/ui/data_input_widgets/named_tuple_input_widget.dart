import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/named_tuple.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/ui/data_input_widgets/data_item_input_widget.dart';
import 'package:provider/provider.dart';

class NamedTupleInputWidget extends StatelessWidget {
  const NamedTupleInputWidget(
      {super.key, required this.namedTupleDataInstance});

  final NamedTupleData namedTupleDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NamedTupleData>.value(
      value: namedTupleDataInstance,
      child: Card(
        elevation: 4,
        child: ExpansionTile(title: const Text("Named Tuple"), children: [
          Consumer<NamedTupleData>(
            builder: (context, namedTupleData, child) {
              List<Widget> children = [];
              for (var element in namedTupleData.elements.entries) {
                DataItem dataItem = element.value;
                children.add(DataItemInputWidget(dataItem: dataItem));
              }
              return ListView(
                shrinkWrap: true,
                children: children,
              );
            },
          )
        ]),
      ),
    );
  }
}
