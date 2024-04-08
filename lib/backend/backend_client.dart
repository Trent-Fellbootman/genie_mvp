import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:genie_mvp/backend/backend_base.dart';
import 'package:genie_mvp/backend/mock_backend_client.dart';
import 'package:genie_mvp/backend/remote_backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/backend_metadata.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_generation.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_generation.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:genie_mvp/data_models/backend_api/login.dart';
import 'package:genie_mvp/data_models/data_types/single_value_provider.dart';

const storage = FlutterSecureStorage();

const tokenKeyName = 'access_token';

class BackendClient {
  static String? token;
  static String? username;

  static SingleValueProvider<double?> computeBalanceProvider =
      SingleValueProvider(value: null);

  static final BackendBase _backend = RemoteBackendClient();

  static String getUsername() {
    return username!;
  }

  static Future<MiniAppGenerationResponse> generateMiniApp(
      MiniAppGenerationRequest request) async {
    MiniAppGenerationResponse response =
        await _backend.generateMiniApp(token!, request);

    // update compute balance
    _refreshComputeBalance();

    return response;
  }

  /// Login with credentials to get a new token.
  ///
  /// On success, validates the token, saves the token and sets the username.
  static Future<void> login(LoginCredentials loginCredentials) async {
    String token = await _backend.login(loginCredentials);
    await storage.write(key: tokenKeyName, value: token);
    await setUpData();
  }

  static Future<BackendMetadata> getBackendMetadata() async {
    return await _backend.getBackendMetadata(token!);
  }

  static SingleValueProvider<double?> getComputeBalanceProvider() {
    return computeBalanceProvider;
  }

  static Future<MiniAppRunResponse> runMiniApp(
      MiniAppRunRequest request) async {
    MiniAppRunResponse response = await _backend.runMiniApp(token!, request);

    // update compute balance
    _refreshComputeBalance();

    return response;
  }

  static Future<MiniAppSearchPageResponse> searchPage(
      MiniAppSearchPageRequest request) async {
    return await _backend.searchPage(token!, request);
  }

  static Future<FileDownloadResponse> downloadFile(
      FileDownloadRequest request) async {
    return await _backend.downloadFile(token!, request);
  }

  static Future<FileUploadResponse> uploadFile(
      FileUploadRequest request) async {
    return await _backend.uploadFile(token!, request);
  }

  /// Reads and validates the stored token,
  /// throwing an exception if the token is invalid.
  ///
  /// If everything is successful,
  /// sets the static token and username fields
  /// to the saved token and retrieved username.
  ///
  /// Also refreshes the compute balance.
  static Future<void> setUpData() async {
    token = null;
    username = null;

    // read the token
    String? accessToken = await storage.read(key: tokenKeyName);

    if (accessToken == null) {
      throw Exception("No token found.");
    }

    // validate the token
    String retrievedUsername = await _backend.validateToken(accessToken);

    token = accessToken;
    username = retrievedUsername;

    await _refreshComputeBalance();
  }

  static Future<void> _refreshComputeBalance() async {
    computeBalanceProvider.value = null;

    double? computeBalance;

    while (true) {
      try {
        double balance = await _backend.getComputeBalance(token!);
        computeBalance = balance;
        break;
      } catch (e) {
        // wait for 5 seconds to avoid overwhelming the backend
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }
    }

    computeBalanceProvider.value = computeBalance;
  }
}
