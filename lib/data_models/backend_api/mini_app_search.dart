import '../mini_app/mini_app_specification_data.dart';

class MiniAppSearchParameters {
  const MiniAppSearchParameters({required this.searchQuery});

  final String searchQuery;
}

/// A request for retrieving a page of search results.
class MiniAppSearchPageRequest {
  const MiniAppSearchPageRequest({required this.searchParameters, required this.pageIndex, required this.pageSize});

  final MiniAppSearchParameters searchParameters;
  final int pageIndex;
  final int pageSize;
}

/// A response of `MiniAppSearchPageRequest`
class MiniAppSearchPageResponse {
  const MiniAppSearchPageResponse({required this.miniAppSpecifications});

  final List<MiniAppSpecification> miniAppSpecifications;
}
