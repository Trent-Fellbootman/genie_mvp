import 'string_data.dart';
import 'list_data.dart';

enum DataItemType { string }

class DataItem {
  DataItem({required this.dataItemType, this.stringData});

  final DataItemType dataItemType;
  StringData? stringData;
  ListData? listData;
}
