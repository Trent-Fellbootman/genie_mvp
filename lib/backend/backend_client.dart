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

class BackendClient {
  static final BackendBase _backend = RemoteBackendClient();

  static Future<MiniAppGenerationResponse> generateMiniApp(
      MiniAppGenerationRequest request) async {
    return await _backend.generateMiniApp(request);
  }

  static Future<void> login(LoginCredentials loginCredentials) async {
    return await _backend.login(loginCredentials);
  }

  static Future<BackendMetadata> getBackendMetadata() async {
    return await _backend.getBackendMetadata();
  }

  Future<double> getComputeBalance() async {
    return await _backend.getComputeBalance();
  }

  static Future<MiniAppRunResponse> runMiniApp(
      MiniAppRunRequest request) async {
    return await _backend.runMiniApp(request);
  }

  static Future<MiniAppSearchPageResponse> searchPage(
      MiniAppSearchPageRequest request) async {
    return await _backend.searchPage(request);
  }

  static Future<FileDownloadResponse> downloadFile(FileDownloadRequest request) async {
    return await _backend.downloadFile(request);
  }

  static Future<FileUploadResponse> uploadFile(FileUploadRequest request) async {
    return await _backend.uploadFile(request);
  }

  static Future<void> setUpToken() async {
    return await _backend.setUpToken();
  }
}
