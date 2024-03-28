import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/data_types/integer_data.dart';
import 'package:genie_mvp/ui/data_input_widgets/data_item_input_widget.dart';
import 'package:provider/provider.dart';

class MiniAppView extends StatelessWidget {
  MiniAppView({super.key, required this.miniAppSpecification}) {
    inputDataItem = DataItem.createDefaultDataItem(
        miniAppSpecification.inputOutputSpecification.inputTypeDeclaration);
    outputDataItem = DataItem.createDefaultDataItem(
        miniAppSpecification.inputOutputSpecification.outputTypeDeclaration);
  }

  final MiniAppSpecification miniAppSpecification;
  late final DataItem inputDataItem;
  late final DataItem outputDataItem;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // title
        Text(miniAppSpecification.metadata.name,
            style: Theme.of(context).textTheme.displayLarge),
        // description
        Markdown(shrinkWrap: true, data: miniAppSpecification.metadata.description),
        // input title
        Text("Input", style: Theme.of(context).textTheme.headlineLarge),
        // input data widget
        DataItemInputWidget(dataItem: inputDataItem),
        // Run button
        FilledButton.tonal(
            onPressed: () {
              // TODO
            },
            child:
                Text("Run", style: Theme.of(context).textTheme.titleLarge)),
        // output title
        Text("Output", style: Theme.of(context).textTheme.headlineLarge),
        // output data widget
        DataItemInputWidget(dataItem: outputDataItem),
      ],
    );
  }
}
