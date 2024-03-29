import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/backend_api/ai_mini_app_generation.dart';

class AIMiniAppGenerationView extends StatefulWidget {
  const AIMiniAppGenerationView({super.key});

  @override
  State createState() => _AIMiniAppGenerationViewState();
}

class _AIMiniAppGenerationViewState extends State<AIMiniAppGenerationView> {
  Future<AIMiniAppGenerationResponse>? _aiMiniAppGenerationResponse;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        // title
        Text(
          "AI Mini App Generation",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }
}
