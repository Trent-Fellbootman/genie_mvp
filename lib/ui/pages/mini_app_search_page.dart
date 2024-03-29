import 'package:flutter/material.dart';

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
            // search view
            const Expanded(child: MiniAppSearchView()),
            // AI app generation redirection widget
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Didn't find the app you want? Try",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ai_app_generation_page');
                  },
                  child: Text(
                    "AI App Generation",
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
