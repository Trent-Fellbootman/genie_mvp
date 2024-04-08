import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_generation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'mini_app_view.dart';

class MiniAppGenerationView extends StatefulWidget {
  const MiniAppGenerationView({super.key});

  @override
  State createState() => _MiniAppGenerationViewState();
}

class _MiniAppGenerationViewState extends State<MiniAppGenerationView> {
  Future<MiniAppGenerationResponse>? _miniAppGenerationResponseFuture;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isGenerating = false;
  String? _demandDescription;

  Future<MiniAppGenerationResponse> _generateMiniApp(
      MiniAppGenerationRequest request) async {
    return BackendClient.generateMiniApp(request).whenComplete(() {
      setState(() {
        _isGenerating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                child: TextFormField(
                  onChanged: (value) {
                    _demandDescription = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入需求描述！';
                    }
                    return null;
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
              _isGenerating
                  ? Card(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('正在生成小程序，这一般需要30秒-1分钟...'),
                          LoadingAnimationWidget.fourRotatingDots(
                            color: Theme.of(context).colorScheme.primary,
                            size: 32.0,
                          ),
                        ],
                      ),
                    )
                  : FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _miniAppGenerationResponseFuture = _generateMiniApp(
                                MiniAppGenerationRequest(
                                    demandDescription: _demandDescription!));
                            _isGenerating = true;
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "使用AI生成小程序",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary),
                          ),
                          FutureBuilder(
                            future: BackendClient.getBackendMetadata(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color:
                                          Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    Text(
                                      snapshot.data!
                                          .costPerSuccessfulMiniAppGeneration
                                          .toString(),
                                    )
                                  ],
                                );
                              } else {
                                return LoadingAnimationWidget.discreteCircle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 16,
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
        // generated mini app view
        _miniAppGenerationResponseFuture == null
            ? Container()
            : FutureBuilder(
                future: _miniAppGenerationResponseFuture!,
                builder: (context, snapshot) {
                  Widget placeholder = Container();

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return placeholder;
                  }

                  if (snapshot.hasData) {
                    return MiniAppView(
                        miniAppSpecification:
                            snapshot.data!.miniAppSpecification);
                  } else if (snapshot.hasError) {
                    return Text('An error occurred: ${snapshot.error}');
                  } else {
                    return placeholder;
                  }
                },
              ),
      ],
    );
  }
}
