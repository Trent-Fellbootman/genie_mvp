class BackendMetadata {
  const BackendMetadata({
    required this.costPerSuccessfulMiniAppGeneration,
  });

  final double costPerSuccessfulMiniAppGeneration;

  static BackendMetadata fromDataTree(dynamic data) {
    assert(data is Map<String, dynamic>);

    return BackendMetadata(
      costPerSuccessfulMiniAppGeneration: data['cost_per_successful_mini_app_generation'],
    );
  }
}
