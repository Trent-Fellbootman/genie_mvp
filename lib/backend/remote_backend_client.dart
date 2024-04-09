import 'dart:convert';

import 'package:genie_mvp/backend/backend_base.dart';
import 'package:genie_mvp/data_models/backend_api/backend_metadata.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_run.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/backend_api/mini_app_generation.dart';
import 'package:genie_mvp/data_models/backend_api/login.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/data_item.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:io';
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
const int computeBalanceRefreshMaxRetries = 5;

class RemoteBackendClient implements BackendBase {
  @override
  Future<MiniAppSearchPageResponse> searchPage(
      String token, MiniAppSearchPageRequest request) async {
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
      options: Options(headers: getAuthorizationHeader(token)),
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
  Future<MiniAppRunResponse> runMiniApp(
      String token, MiniAppRunRequest request) async {
    final data = {
      'mini_app_id': request.appID,
      'input_data': request.inputData.toDataTree(),
    };

    final Response response = await dio.post('$apiBaseURL/run-mini-app',
        data: data, options: Options(headers: getAuthorizationHeader(token)));

    return MiniAppRunResponse(
        outputData: DataItem.fromDataTree(response.data['output_data']));
  }

  @override
  Future<MiniAppGenerationResponse> generateMiniApp(
      String token, MiniAppGenerationRequest request) async {
    final data = {'demand_description': request.demandDescription};

    final Response response = await dio.post('$apiBaseURL/generate-mini-app',
        data: data, options: Options(headers: getAuthorizationHeader(token)));

    return MiniAppGenerationResponse(
        miniAppSpecification: MiniAppSpecification.fromDataTree(
            response.data['mini_app_specification']));
  }

  @override
  Future<String> validateToken(String accessToken) async {
    final Response response = await dio.get("$apiBaseURL/ping",
        options: Options(headers: {
          "Authorization": "Bearer $accessToken",
        }));

    assert(response.data is String);

    return response.data;
  }

  @override
  Future<String> login(LoginCredentials loginCredentials) async {
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

    return response.data['access_token'];
  }

  Map<String, String> getAuthorizationHeader(String token) =>
      {"Authorization": "Bearer $token"};

  @override
  Future<FileDownloadResponse> downloadFile(
      String token, FileDownloadRequest request) async {
    final response = await dio.get(
      '$apiBaseURL/download-file',
      queryParameters: {'file_id': request.fileID},
      options: Options(
        responseType: ResponseType.bytes,
        headers: getAuthorizationHeader(token),
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
  Future<FileUploadResponse> uploadFile(
      String token, FileUploadRequest request) async {
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
      options: Options(headers: getAuthorizationHeader(token)),
    );

    // Check the response status and body
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to upload file. Status code: ${response.statusCode}');
    }

    assert(response.data is String);

    return FileUploadResponse(fileID: response.data);
  }

  @override
  Future<BackendMetadata> getBackendMetadata(String token) async {
    Response response = await dio.get('$apiBaseURL/backend-metadata',
        options: Options(headers: getAuthorizationHeader(token)));

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to get backend metadata. Status code: ${response.statusCode}');
    }

    return BackendMetadata.fromDataTree(response.data['backend_metadata']);
  }

  @override
  Future<double> getComputeBalance(String token) async {
    Response response = await dio.get(
      '$apiBaseURL/get-compute-balance',
      options: Options(headers: getAuthorizationHeader(token)),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to get compute balance. Status code: ${response.statusCode}');
    }

    return (response.data as num).toDouble();
  }
}
