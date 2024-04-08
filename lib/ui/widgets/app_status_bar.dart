import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data_models/data_types/single_value_provider.dart';

/// The status bar that displays the username and user's compute balance.
class AppStatusBar extends StatelessWidget {
  const AppStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          child: Icon(
            Icons.person,
            size: 32,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          BackendClient.getUsername(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Expanded(child: Container()),
        const Icon(
          Icons.monetization_on,
          size: 32,
        ),
        const SizedBox(width: 2),
        ChangeNotifierProvider.value(
          value: BackendClient.getComputeBalanceProvider(),
          child: Consumer<SingleValueProvider<double?>>(
            builder: (context, value, child) {
              return value.value == null
                  ? LoadingAnimationWidget.discreteCircle(
                      color: Theme.of(context).colorScheme.primary, size: 32)
                  : Text(
                      value.value!.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleLarge,
                    );
            },
          ),
        )
      ],
    );
  }
}
