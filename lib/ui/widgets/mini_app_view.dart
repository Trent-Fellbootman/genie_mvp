import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/data_types/atomic_notifier.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'data_input_widgets/data_item_input_widget.dart';
import 'data_display_widgets/data_item_display_widget.dart';

class MiniAppView extends StatefulWidget {
  const MiniAppView({super.key, required this.miniAppSpecification});

  final MiniAppSpecification miniAppSpecification;

  @override
  State createState() => _MiniAppViewState();
}

class _MiniAppViewState extends State<MiniAppView> {
  _MiniAppViewState();

  bool _isRunning = false;

  Future<MiniAppRunResponse> _runMiniApp(MiniAppRunRequest request) async {
    setState(() {
      _isRunning = true;
    });

    return BackendClient.runMiniApp(request).whenComplete(() {
      setState(() {
        _isRunning = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    inputDataItem = DataItem.createDefaultDataItem(widget
        .miniAppSpecification.inputOutputSpecification.inputTypeDeclaration);
  }

  late final DataItem inputDataItem;
  final AtomicNotifier<Future<MiniAppRunResponse>?> runResultFutureNotifier =
      AtomicNotifier(value: null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // title
        Text(widget.miniAppSpecification.metadata.name,
            style: Theme.of(context).textTheme.displaySmall),
        // description
        Markdown(
            shrinkWrap: true,
            data: widget.miniAppSpecification.metadata.description),
        // input title
        Text("输入", style: Theme.of(context).textTheme.headlineMedium),
        // input data widget
        DataItemInputWidget(dataItem: inputDataItem),
        // Run button
        _isRunning
            ? LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              )
            : FilledButton(
                onPressed: () {
                  runResultFutureNotifier.value = _runMiniApp(
                    MiniAppRunRequest(
                        appID: widget.miniAppSpecification.metadata.miniAppID,
                        inputData: inputDataItem),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("运行！",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    Icon(
                      Icons.monetization_on,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    Text(
                        widget
                            .miniAppSpecification.metadata.costPerSuccessfulRun
                            .toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary))
                  ],
                )),
        // output title
        Text("输出", style: Theme.of(context).textTheme.headlineMedium),
        // output data widget
        ChangeNotifierProvider.value(
          value: runResultFutureNotifier,
          child: Consumer<AtomicNotifier<Future<MiniAppRunResponse>?>>(
            builder: (context, notifier, child) {
              Widget placeholder = Container();
              return notifier.value == null
                  ? Container()
                  : FutureBuilder(
                      future: notifier.value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return placeholder;
                        }
                        if (snapshot.hasData) {
                          return DataItemDisplayWidget(
                            dataItem: snapshot.data!.outputData,
                          );
                        } else if (snapshot.hasError) {
                          return Text("An error occurred: ${snapshot.error}");
                        } else {
                          return placeholder;
                        }
                      },
                    );
            },
          ),
        )
      ],
    );
  }
}
