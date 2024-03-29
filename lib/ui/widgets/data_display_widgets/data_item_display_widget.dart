import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import '../data_input_widgets/data_item_input_widget.dart';

class DataItemDisplayWidget extends StatelessWidget {
  const DataItemDisplayWidget({super.key, required this.dataItem});

  final DataItem dataItem;

  @override
  Widget build(BuildContext context) {
    // TODO: add a proper implementation
    return DataItemInputWidget(dataItem: dataItem);
  }
}
