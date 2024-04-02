import 'package:flutter/material.dart';

import 'package:genie_mvp/ui/widgets/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: LoginView(),
      ),
    );
  }
}
