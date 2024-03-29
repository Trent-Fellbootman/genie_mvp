import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/mini_app_specification_data.dart';
import 'package:genie_mvp/ui/mini_app_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MiniAppSearchView extends StatefulWidget {
  const MiniAppSearchView({super.key});

  @override
  State createState() => _MiniAppSearchViewState();
}

class _MiniAppSearchViewState extends State<MiniAppSearchView> {
  Future<MiniAppSearchSessionInitiateResponse>?
      searchSessionInitiateResponseFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // search bar
        Container(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            leading: const Icon(Icons.search),
            onSubmitted: (value) {
              setState(() {
                searchSessionInitiateResponseFuture =
                    BackendClient.initiateSearchSession(
                        MiniAppSearchSessionInitiateRequest(searchString: value));
              });
            },
          ),
        ),
        Expanded(
            child: searchSessionInitiateResponseFuture == null
                ? Container()
                : FutureBuilder(
                    future: searchSessionInitiateResponseFuture!,
                    builder: (context, snapshot) {
                      Widget loadingAnimationWidget = Container(
                        alignment: Alignment.topCenter,
                        child: LoadingAnimationWidget.threeRotatingDots(
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      );
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingAnimationWidget;
                      }

                      if (snapshot.hasData) {
                        return MiniAppSearchResultDisplayView(
                            searchSessionToken:
                                snapshot.data!.searchSessionToken);
                      } else if (snapshot.hasError) {
                        return Text("An error occurred: ${snapshot.error}");
                      } else {
                        return loadingAnimationWidget;
                      }
                    })),
      ],
    );
  }
}

class MiniAppSearchResultDisplayView extends StatefulWidget {
  const MiniAppSearchResultDisplayView({
    super.key,
    required this.searchSessionToken,
  });

  final String searchSessionToken;

  @override
  State<MiniAppSearchResultDisplayView> createState() =>
      _MiniAppSearchResultDisplayViewState();
}

class _MiniAppSearchResultDisplayViewState
    extends State<MiniAppSearchResultDisplayView> {
  static const int _pageSize = 5;

  final PagingController<int, MiniAppSpecification> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final MiniAppSearchPageResponse response =
          await BackendClient.pageSearchSession(
        MiniAppSearchPageRequest(
          searchSessionToken: widget.searchSessionToken,
          pageIndex: pageKey,
          pageSize: _pageSize,
        ),
      );

      final List<MiniAppSpecification> newItems =
          response.miniAppSpecifications;

      final bool isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
      shrinkWrap: true,
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<MiniAppSpecification>(
        itemBuilder: (context, item, index) {
          return MiniAppCard(miniAppSpecification: item);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class MiniAppCard extends StatelessWidget {
  const MiniAppCard({
    super.key,
    required this.miniAppSpecification,
  });

  final MiniAppSpecification miniAppSpecification;

  @override
  Widget build(BuildContext context) {
    // TODO: add appropriate implementation
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
          child: MiniAppView(miniAppSpecification: miniAppSpecification)),
    );
  }
}
