import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/backend_api/ai_mini_app_generation.dart';
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

class LoginCredentials {
  const LoginCredentials({required this.userID, required this.password});

  final String userID;
  final String password;
}

class BackendClient {
  static Token? token;

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

  /// Retrieves a page of items for a search session.
  static Future<MiniAppSearchPageResponse> searchPage(
      MiniAppSearchPageRequest request) async {
    // TODO: remove mock implementation
    MiniAppSpecification mockSpecification = mockMiniAppSpecification;
    await Future.delayed(const Duration(seconds: 1));
    return MiniAppSearchPageResponse(
        miniAppSpecifications:
            List.filled(request.pageSize, mockSpecification));
  }

  // TODO: add operation for closing a search session

  /// Runs a mini app, returning the output data.
  static Future<MiniAppRunResponse> runMiniApp(
      MiniAppRunRequest request) async {
    // TODO: remove mock implementation
    Random rng = Random();
    await Future.delayed(const Duration(seconds: 1));
    if (rng.nextBool()) {
      return MiniAppRunResponse(outputData: request.inputData);
    } else {
      throw Exception("An error occurred.");
    }
  }

  static Future<AIMiniAppGenerationResponse> aiGenerateMiniApp(
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

  /// Tries to read the token from local storage
  /// and validate the token.
  ///
  /// Returns error if token does not exist
  /// or is not valid.
  static Future<void> setUpToken() async {
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

  /// Retrieves a new token and updates the stored token.
  static Future<void> login(LoginCredentials loginCredentials) async {
    await Future.delayed(Duration(seconds: 1));
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
}
