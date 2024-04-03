import 'package:genie_mvp/backend/backend_base.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/backend_api/ai_mini_app_generation.dart';
import 'package:genie_mvp/data_models/backend_api/login.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/data_types/integer_data.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:math';
import 'package:dio/dio.dart';

class Token {
  const Token({required this.accessToken});

  final String accessToken;
}

final dio = Dio();
const storage = FlutterSecureStorage();

// TODO: replace with real url
const String apiBaseURL = "http://127.0.0.1:8000";

class RemoteBackendClient implements BackendBase {
  Token? token;

  static MiniAppSpecification mockMiniAppSpecification = MiniAppSpecification(
    inputOutputSpecification: MiniAppInputOutputSpecification(
      inputTypeDeclaration: DataItemType(
          basicDataItemType: BasicDataItemType.array,
          arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
              itemType: DataItemType(
            basicDataItemType: BasicDataItemType.string,
          ))),
      outputTypeDeclaration:
          DataItemType(basicDataItemType: BasicDataItemType.string),
    ),
    metadata: MiniAppSpecificationMetadata(
      miniAppID: "test-id",
      name: "随机选择器",
      description: """随机选择器，选择困难症的福音！

从输入的多个句子中随机选一个输出。
""",
      likes: IntegerData(value: 1),
      dislikes: IntegerData(value: 0),
    ),
  );

  @override
  Future<MiniAppSearchPageResponse> searchPage(
      MiniAppSearchPageRequest request) async {
    final searchParameters = request.searchParameters;
    final data = {
      'parameters': {
        'query': searchParameters.searchQuery,
      },
      'page_index': request.pageIndex,
      'page_size': request.pageSize
    };

    final Response response = await dio.post(
      '$apiBaseURL/search-page',
      data: data,
      options: Options(headers: getAuthorizationHeader()),
    );

    List<dynamic> miniAppSpecificationsData =
        response.data['mini_app_specifications'];

    List<MiniAppSpecification> miniAppSpecifications = miniAppSpecificationsData
        .map((e) => MiniAppSpecification.fromDataTree(e))
        .toList();

    return MiniAppSearchPageResponse(
      miniAppSpecifications: miniAppSpecifications,
    );
  }

  @override
  Future<MiniAppRunResponse> runMiniApp(MiniAppRunRequest request) async {
    final data = {
      'mini_app_id': request.appID,
      'input_data': request.inputData.toDataTree(),
    };

    final Response response = await dio.post('$apiBaseURL/run-mini-app',
        data: data, options: Options(headers: getAuthorizationHeader()));

    return MiniAppRunResponse(
        outputData: DataItem.fromDataTree(response.data['output_data']));
  }

  @override
  Future<AIMiniAppGenerationResponse> aiGenerateMiniApp(
      AIMiniAppGenerationRequest request) async {
    // TODO: remove mock implementation
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextBool()) {
      return AIMiniAppGenerationResponse(
          miniAppSpecification: mockMiniAppSpecification);
    } else {
      throw Exception("An error occurred.");
    }
  }

  @override
  Future<void> setUpToken() async {
    token = null;

    final String? accessToken = await storage.read(key: 'access-token');

    if (accessToken == null) {
      throw Exception("Token not found in local storage!");
    }

    // ensure that the token is valid
    final Response response = await dio.post("$apiBaseURL/ping",
        options: Options(headers: {
          "Authorization": "Bearer $accessToken",
        }));

    token = Token(accessToken: accessToken);
  }

  @override
  Future<void> login(LoginCredentials loginCredentials) async {
    // retrieve a new token
    final Response response = await dio.post(
      "$apiBaseURL/token",
      data: {
        "username": loginCredentials.userID,
        "password": loginCredentials.password,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    assert(response.data['access_token'] is String);

    // update the token stored in memory
    token = Token(accessToken: response.data['access_token']);

    // update the token stored on disk
    await storage.write(key: "access-token", value: token!.accessToken);
  }

  Map<String, String> getAuthorizationHeader() =>
      {"Authorization": "Bearer ${token!.accessToken}"};
}
