import 'package:flutter/material.dart';
import '../widgets/ai_app_generation_view.dart';

class AIMiniAppGenerationPage extends StatelessWidget {
  const AIMiniAppGenerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AIMiniAppGenerationView(),
      ),
    );
  }
}
