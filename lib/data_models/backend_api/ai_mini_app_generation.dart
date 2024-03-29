import '../mini_app/mini_app_specification_data.dart';

class AIMiniAppGenerationRequest {
  const AIMiniAppGenerationRequest({required this.inputPrompt});

  final String inputPrompt;
}

class AIMiniAppGenerationResponse {
  const AIMiniAppGenerationResponse({required this.miniAppSpecification});

  final MiniAppSpecification miniAppSpecification;
}
