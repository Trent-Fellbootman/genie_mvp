import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/ai_mini_app_generation.dart';
import 'package:genie_mvp/ui/mini_app_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AIMiniAppGenerationView extends StatefulWidget {
  const AIMiniAppGenerationView({super.key});

  @override
  State createState() => _AIMiniAppGenerationViewState();
}

class _AIMiniAppGenerationViewState extends State<AIMiniAppGenerationView> {
  Future<AIMiniAppGenerationResponse>? _aiMiniAppGenerationResponse;
  String? prompt;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        // title
        Align(
          alignment: Alignment.center,
          child: Text(
            "AI Mini App Generation",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        // input box
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              prompt = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Describe the app you want to generate...",
            ),
            maxLines: null,
          ),
        ),
        // generate button
        FilledButton.tonal(
          onPressed: () {
            setState(() {
              if (prompt != null) {
                _aiMiniAppGenerationResponse = BackendClient.aiGenerateMiniApp(
                    AIMiniAppGenerationRequest(inputPrompt: prompt!));
              }
            });
          },
          child: Text(
            "Generate",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // generated mini app view
        _aiMiniAppGenerationResponse == null
            ? Container()
            : FutureBuilder(
                future: _aiMiniAppGenerationResponse!,
                builder: (context, snapshot) {
                  Widget loadingAnimationWidget =
                      LoadingAnimationWidget.hexagonDots(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32.0,
                  );

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingAnimationWidget;
                  }

                  if (snapshot.hasData) {
                    return MiniAppView(
                        miniAppSpecification:
                            snapshot.data!.miniAppSpecification);
                  } else if (snapshot.hasError) {
                    return Text('An error occurred: ${snapshot.error}');
                  } else {
                    return loadingAnimationWidget;
                  }
                },
              ),
      ],
    );
  }
}
