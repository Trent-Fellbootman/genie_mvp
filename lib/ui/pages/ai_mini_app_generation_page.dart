import 'package:flutter/material.dart';
import '../widgets/ai_app_generation_view.dart';

class AIMiniAppGenerationPage extends StatelessWidget {
  const AIMiniAppGenerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // back bar
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // AI app generation view
            const Expanded(child: AIMiniAppGenerationView()),
          ],
        ),
      ),
    );
  }
}
