import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:genie_mvp/backend/backend_client.dart';

class SetUpTokenPage extends StatefulWidget {
  const SetUpTokenPage({super.key});

  @override
  State createState() => _SetUpTokenPageState();
}

class _SetUpTokenPageState extends State<SetUpTokenPage> {
  @override
  void initState() {
    super.initState();

    // start background coroutine for validating the token
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _checkToken();
      },
    );
  }

  Future<void> _checkToken() async {
    try {
      await BackendClient.setUpToken();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            child: LoadingAnimationWidget.twoRotatingArc(
                color: Theme.of(context).colorScheme.primary, size: 128)),
      ),
    );
  }
}
