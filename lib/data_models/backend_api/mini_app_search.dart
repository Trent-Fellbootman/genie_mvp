import '../mini_app/mini_app_specification_data.dart';

/// Initial query used to send search parameter to the server;
/// Page requests can be processed only after this query is sent.
class MiniAppSearchSessionInitiateRequest {
  const MiniAppSearchSessionInitiateRequest({required this.searchString});

  final String searchString;
}

/// Response of `MiniAppSearchSessionInitiateRequest`
class MiniAppSearchSessionInitiateResponse {
  const MiniAppSearchSessionInitiateResponse({required this.searchSessionToken});

  final String searchSessionToken;
}

/// A request for retrieving a page of search results.
class MiniAppSearchPageRequest {
  const MiniAppSearchPageRequest({required this.searchSessionToken, required this.pageIndex, required this.pageSize});

  final String searchSessionToken;
  final int pageIndex;
  final int pageSize;
}

/// A response of `MiniAppSearchPageRequest`
class MiniAppSearchPageResponse {
  const MiniAppSearchPageResponse({required this.miniAppSpecifications});

  final List<MiniAppSpecification> miniAppSpecifications;
}
