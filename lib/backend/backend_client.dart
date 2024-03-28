import 'package:genie_mvp/data_models/backend_api/mini_app_search.dart';
import 'package:genie_mvp/data_models/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/data_types/integer_data.dart';

class BackendClient {
  static String? token;

  /// Initiates a search session.
  static Future<MiniAppSearchSessionInitiateResponse> initiateSearchSession(
      MiniAppSearchSessionInitiateRequest request) async {
    throw UnimplementedError();
  }

  /// Retrieves a page of items for a search session.
  static Future<MiniAppSearchPageResponse> pageSearchSession(
      MiniAppSearchPageRequest request) async {
    // TODO: remove mock implementation
    MiniAppSpecification mockSpecification = MiniAppSpecification(
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
          name: "随机选择器",
          description: """随机选择器，选择困难症的福音！

从输入的多个句子中随机选一个输出。
""",
          likes: IntegerData(value: 1),
          dislikes: IntegerData(value: 0),
        ));
    await Future.delayed(const Duration(seconds: 1));
    return MiniAppSearchPageResponse(
        miniAppSpecifications:
            List.filled(request.pageSize, mockSpecification));
  }
}
