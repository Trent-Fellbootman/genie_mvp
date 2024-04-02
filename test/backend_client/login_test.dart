import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/login.dart';

void main() {
  // TODO: add logic check
  test(
      "Test that login token can be obtained successfully and token can be used in later ping operation",
      () async {
    WidgetsFlutterBinding.ensureInitialized();
    await BackendClient.login(
        const LoginCredentials(userID: "string", password: "string"));
  });
}
