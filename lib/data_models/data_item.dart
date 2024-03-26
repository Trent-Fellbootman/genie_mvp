import 'package:flutter/foundation.dart';

import 'string_data.dart';
import 'list_data.dart';

enum DataItemType { string, list }

class DataItem extends ChangeNotifier {
  DataItem({required this.dataItemType, this.stringData, this.listData});

  final DataItemType dataItemType;
  StringData? stringData;
  ListData? listData;
}
