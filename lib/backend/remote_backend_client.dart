import 'dart:convert';

import 'package:genie_mvp/backend/backend_base.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_generation.dart';
import 'package:genie_mvp/data_models/backend_api/login.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/data_types/integer_data.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Token {
  const Token({required this.accessToken});

  final String accessToken;
}

final dio = Dio();
const storage = FlutterSecureStorage();

// TODO: replace with real url
const String apiBaseURL = "http://207.148.88.30:8081";
// const String apiBaseURL = "http://127.0.0.1:8000";

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
  Future<MiniAppGenerationResponse> generateMiniApp(
      MiniAppGenerationRequest request) async {
    final data = {'demand_description': request.demandDescription};

    final Response response = await dio.post('$apiBaseURL/generate-mini-app',
        data: data, options: Options(headers: getAuthorizationHeader()));

    return MiniAppGenerationResponse(
        miniAppSpecification: MiniAppSpecification.fromDataTree(
            response.data['mini_app_specification']));
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

  @override
  Future<FileDownloadResponse> downloadFile(FileDownloadRequest request) async {
    final response = await dio.get(
      '$apiBaseURL/download-file',
      queryParameters: {'file_id': request.fileID},
      options: Options(
        responseType: ResponseType.bytes,
        headers: getAuthorizationHeader(),
      ),
    );

    final String fileNameData =
        response.headers.value('content-disposition')?.split('filename=')[1] ??
            'downloaded_file';
    dynamic fileName = jsonDecode(fileNameData);
    assert(fileName is String);

    // get the download directory
    final Directory downloadDirectory = await getDownloadsDirectory() ??
        Directory('/storage/emulated/0/Download');
    // create the download directory if it doesn't exist
    if (!(await downloadDirectory.exists())) {
      await downloadDirectory.create(recursive: true);
    }

    final File file = File('${downloadDirectory.path}/$fileName');

    await file.writeAsBytes(response.data);

    final String fileSavePath = file.absolute.path;

    return FileDownloadResponse(filepath: fileSavePath);
  }

  @override
  Future<FileUploadResponse> uploadFile(FileUploadRequest request) async {
    // Create a FormData object
    FormData formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(
          request.filepath,
          filename: p.basename(request.filepath),
        ),
      },
    );

    // Make the POST request
    Response response = await dio.post(
      '$apiBaseURL/upload-file', // Replace with your actual URL
      data: formData,
      options: Options(headers: getAuthorizationHeader()),
    );

    // Check the response status and body
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to upload file. Status code: ${response.statusCode}');
    }

    assert(response.data is String);

    return FileUploadResponse(fileID: response.data);
  }
}
