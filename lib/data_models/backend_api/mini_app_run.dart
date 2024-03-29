import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';

class MiniAppRunRequest {
  const MiniAppRunRequest({
    required this.appID,
    required this.inputData,
  });

  final String appID;
  final DataItem inputData;
}

class MiniAppRunResponse {
  const MiniAppRunResponse({
    required this.outputData,
  });

  final DataItem outputData;
}
