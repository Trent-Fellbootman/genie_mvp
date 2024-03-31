import 'package:test/test.dart';
import 'package:genie_mvp/backend/backend_client.dart';

void main() {
  // TODO: add logic check
  test("Test that login token can be obtained successfully", () async {
    Token token = await BackendClient.login(
        const LoginCredentials(username: "johndoe", password: "secret"));
  });
}
