import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/string_data.dart';

class StringInputWidget extends StatelessWidget {
  const StringInputWidget({super.key, required this.stringDataInstance});

  final StringData stringDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StringData>.value(
      value: stringDataInstance,
      child: Consumer<StringData>(
        builder: (context, string, child) => TextFormField(
          initialValue: string.data,
          onChanged: (value) {
            string.data = value;
          },
        ),
      ),
    );
  }
}
