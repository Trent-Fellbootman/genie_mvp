import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';

class MiniAppGenerationRequest {
  const MiniAppGenerationRequest({required this.demandDescription});

  final String demandDescription;
}

class MiniAppGenerationResponse {
  const MiniAppGenerationResponse({required this.miniAppSpecification});

  final MiniAppSpecification miniAppSpecification;
}
