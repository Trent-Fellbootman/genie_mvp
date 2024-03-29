import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/data_types/atomic_notifier.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app_specification_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'data_input_widgets/data_item_input_widget.dart';
import 'data_display_widgets/data_item_display_widget.dart';

class MiniAppView extends StatelessWidget {
  MiniAppView({super.key, required this.miniAppSpecification}) {
    inputDataItem = DataItem.createDefaultDataItem(
        miniAppSpecification.inputOutputSpecification.inputTypeDeclaration);
  }

  final MiniAppSpecification miniAppSpecification;
  late final DataItem inputDataItem;
  final AtomicNotifier<Future<MiniAppRunResponse>?> runResultFutureNotifier =
      AtomicNotifier(value: null);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // title
        Text(miniAppSpecification.metadata.name,
            style: Theme.of(context).textTheme.displayLarge),
        // description
        Markdown(
            shrinkWrap: true, data: miniAppSpecification.metadata.description),
        // input title
        Text("Input", style: Theme.of(context).textTheme.headlineLarge),
        // input data widget
        DataItemInputWidget(dataItem: inputDataItem),
        // Run button
        FilledButton.tonal(
            onPressed: () {
              print("pressed");
              runResultFutureNotifier.value = BackendClient.runMiniApp(
                MiniAppRunRequest(
                    appID: miniAppSpecification.metadata.miniAppID,
                    inputData: inputDataItem),
              );
            },
            child: Text("Run", style: Theme.of(context).textTheme.titleLarge)),
        // output title
        Text("Output", style: Theme.of(context).textTheme.headlineLarge),
        // output data widget
        ChangeNotifierProvider.value(
          value: runResultFutureNotifier,
          child: Consumer<AtomicNotifier<Future<MiniAppRunResponse>?>>(
            builder: (context, notifier, child) {
              Widget loadingAnimationWidget =
                  LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              );
              return notifier.value == null
                  ? Container()
                  : FutureBuilder(
                      future: notifier.value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadingAnimationWidget;
                        }
                        if (snapshot.hasData) {
                          return DataItemDisplayWidget(
                            dataItem: snapshot.data!.outputData,
                          );
                        } else if (snapshot.hasError) {
                          return Text("An error occurred: ${snapshot.error}");
                        } else {
                          return loadingAnimationWidget;
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
