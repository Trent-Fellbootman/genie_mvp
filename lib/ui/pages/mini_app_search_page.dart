import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/data_types/single_value_provider.dart';
import 'package:genie_mvp/ui/widgets/app_status_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/mini_app_search_view.dart';

class MiniAppSearchPage extends StatelessWidget {
  const MiniAppSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top bar for displaying user name and compute balance
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const AppStatusBar(),
            ),
            // search view
            const Expanded(child: MiniAppSearchView()),
            // AI app generation redirection widget
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "没有找到想要的APP？试试",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ai_app_generation_page');
                  },
                  child: Text(
                    "用AI生成小程序",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
