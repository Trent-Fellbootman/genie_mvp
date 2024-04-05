import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'mini_app_view.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/backend/backend_client.dart';

class MiniAppSearchView extends StatefulWidget {
  const MiniAppSearchView({super.key});

  @override
  State createState() => _MiniAppSearchViewState();
}

class _MiniAppSearchViewState extends State<MiniAppSearchView> {
  static const int _pageSize = 5;
  MiniAppSearchParameters? _searchParameters;
  final PagingController<int, MiniAppSpecification> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // search bar
        Container(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: "试试搜索你需要的功能，比如“随机选食堂”",
            onSubmitted: (value) {
              setState(() {
                _searchParameters = MiniAppSearchParameters(searchQuery: value);
                _pagingController.refresh();
              });
            },
          ),
        ),
        _searchParameters == null
            ? Container()
            : Expanded(
                child: PagedListView(
                  shrinkWrap: true,
                  pagingController: _pagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<MiniAppSpecification>(
                    itemBuilder: (context, item, index) {
                      return MiniAppCard(miniAppSpecification: item);
                    },
                  ),
                ),
              ),
      ],
    );
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final MiniAppSearchPageResponse response = await BackendClient.searchPage(
        MiniAppSearchPageRequest(
          searchParameters: _searchParameters!,
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
