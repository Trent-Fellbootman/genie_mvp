import 'package:genie_mvp/backend/backend_base.dart';
import 'package:genie_mvp/data_models/backend_api/backend_metadata.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_generation.dart';
import 'package:genie_mvp/data_models/backend_api/login.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/data_types/integer_data.dart';
import 'package:genie_mvp/data_models/data_types/single_value_provider.dart';

import 'dart:math';
import 'package:dio/dio.dart';

final dio = Dio();

const double failRate = 0.1;

class MockBackendClient implements BackendBase {
  static SingleValueProvider<double?> computeBalanceProvider =
      SingleValueProvider(
    value: 5.0,
  );

  static MiniAppSpecification mockMiniAppSpecification = MiniAppSpecification(
    inputOutputSpecification: MiniAppInputOutputSpecification(
      inputTypeDeclaration: DataItemType(
          basicDataItemType: BasicDataItemType.array,
          arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
              itemType: DataItemType(
            basicDataItemType: BasicDataItemType.file,
          ))),
      outputTypeDeclaration:
          DataItemType(basicDataItemType: BasicDataItemType.file),
    ),
    metadata: MiniAppSpecificationMetadata(
      miniAppID: "test-id",
      name: "随机选择器",
      description: """随机选择器，选择困难症的福音！

从输入的多个句子中随机选一个输出。
""",
      costPerSuccessfulRun: 0.1,
      likes: IntegerData(value: 1),
      dislikes: IntegerData(value: 0),
    ),
  );

  @override
  Future<MiniAppSearchPageResponse> searchPage(
      String token, MiniAppSearchPageRequest request) async {
    MiniAppSpecification mockSpecification = mockMiniAppSpecification;
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));

    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    }

    return MiniAppSearchPageResponse(
        miniAppSpecifications:
            List.filled(request.pageSize, mockSpecification));
  }

  @override
  Future<MiniAppRunResponse> runMiniApp(
      String token, MiniAppRunRequest request) async {
    // TODO: remove mock implementation
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    } else {
      return MiniAppRunResponse(outputData: request.inputData);
    }
  }

  @override
  Future<MiniAppGenerationResponse> generateMiniApp(
      String token, MiniAppGenerationRequest request) async {
    // TODO: remove mock implementation
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 5));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    } else {
      return MiniAppGenerationResponse(
          miniAppSpecification: mockMiniAppSpecification);
    }
  }

  @override
  Future<String> validateToken(
    String accessToken,
  ) async {
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    } else {
      return 'mock_user';
    }
  }

  @override
  Future<String> login(LoginCredentials loginCredentials) async {
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    } else {
      return 'mock_token';
    }
  }

  @override
  Future<FileDownloadResponse> downloadFile(
      String token, FileDownloadRequest request) async {
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    }
    return const FileDownloadResponse(filepath: "mock-path.md");
  }

  @override
  Future<FileUploadResponse> uploadFile(
      String token, FileUploadRequest request) async {
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    }
    return const FileUploadResponse(fileID: "mock-id");
  }

  @override
  Future<BackendMetadata> getBackendMetadata(String token) async {
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    }
    return Future.value(
        const BackendMetadata(costPerSuccessfulMiniAppGeneration: 10.0));
  }

  @override
  Future<double> getComputeBalance(String token) async {
    computeBalanceProvider.value = null;
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextDouble() < failRate) {
      throw Exception("An error occurred.");
    } else {
      return 5.0;
    }
  }
}
