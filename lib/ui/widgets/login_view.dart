import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoggingIn = false;
  final TextEditingController userIDInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // title
          Text('登录', style: Theme.of(context).textTheme.headlineLarge),
          // user ID input
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: userIDInputController,
                decoration: const InputDecoration(
                  hintText: '用户名',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
              ),
              // password input
              TextFormField(
                controller: passwordInputController,
                decoration: const InputDecoration(
                  hintText: '密码',
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
              )
            ]),
          ),
          // login button
          isLoggingIn
              ? LoadingAnimationWidget.fallingDot(
                  color: Theme.of(context).colorScheme.primary, size: 64.0)
              : FilledButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoggingIn = true;
                      });
                      BackendClient.login(LoginCredentials(
                              userID: userIDInputController.text,
                              password: passwordInputController.text))
                          .then((value) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }, onError: (e) {
                        setState(() {
                          isLoggingIn = false;
                        });

                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('登陆失败: ${e.toString()}')),
                          ),
                        );
                      });
                    }
                  },
                  child: Text(
                    '登录',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    userIDInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }
}
