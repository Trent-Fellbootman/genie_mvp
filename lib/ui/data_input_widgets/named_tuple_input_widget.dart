import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/named_tuple.dart';
import 'package:genie_mvp/data_models/data_item.dart';
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
      child: Consumer<NamedTupleData>(
        builder: (context, namedTupleData, child) {
          List<Widget> children = [];
          for (var element in namedTupleData.elements.entries) {
            String key = element.key;
            DataItem dataItem = element.value;
            children.add(ExpansionTile(title: Text(key), children: [
              Card(
                elevation: 4,
                child: DataItemInputWidget(dataItem: dataItem),
              )
            ]));
          }
          return ListView(
            shrinkWrap: true,
            children: children,
          );
        },
      ),
    );
  }
}
