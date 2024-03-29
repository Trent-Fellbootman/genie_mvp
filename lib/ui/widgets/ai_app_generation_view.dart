import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/ai_mini_app_generation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'mini_app_view.dart';

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
            "AI小程序生成",
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
              hintText: "请描述你想要的功能，比如“我有选择困难症，帮我随机选食堂”",
              hintMaxLines: 2,
            ),
            maxLines: null,
          ),
        ),
        // generate button
        FilledButton(
          onPressed: () {
            setState(() {
              if (prompt != null) {
                _aiMiniAppGenerationResponse = BackendClient.aiGenerateMiniApp(
                    AIMiniAppGenerationRequest(inputPrompt: prompt!));
              }
            });
          },
          child: Text(
            "使用AI生成小程序",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
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
