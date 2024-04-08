import 'package:flutter/foundation.dart';

import '../mini_app/mini_app_data_items/data_item.dart';
import '../data_types/integer_data.dart';

class MiniAppInputOutputSpecification extends ChangeNotifier {
  MiniAppInputOutputSpecification({
    required this.inputTypeDeclaration,
    required this.outputTypeDeclaration,
  });

  final DataItemType inputTypeDeclaration;
  final DataItemType outputTypeDeclaration;
}

class MiniAppSpecificationMetadata {
  MiniAppSpecificationMetadata({
    required this.miniAppID,
    required this.description,
    required this.name,
    required this.costPerSuccessfulRun,
    required this.likes,
    required this.dislikes,
  });

  final String miniAppID;
  final String name;
  final String description;
  final double costPerSuccessfulRun;
  final IntegerData likes;
  final IntegerData dislikes;
}

class MiniAppSpecification {
  MiniAppSpecification({
    required this.inputOutputSpecification,
    required this.metadata,
  });

  final MiniAppInputOutputSpecification inputOutputSpecification;
  final MiniAppSpecificationMetadata metadata;

  static MiniAppSpecification fromDataTree(dynamic dataTree) {
    assert(dataTree is Map<String, dynamic>);
    return MiniAppSpecification(
      metadata: MiniAppSpecificationMetadata(
        miniAppID: dataTree['mini_app_id'],
        name: dataTree['name'],
        description: dataTree['description'],
        costPerSuccessfulRun: dataTree['cost_per_successful_run'],
        // TODO: remove mock default value
        likes: IntegerData(value: 0),
        // TODO: remove mock default value
        dislikes: IntegerData(value: 0),
      ),
      inputOutputSpecification: MiniAppInputOutputSpecification(
        inputTypeDeclaration: DataItemType.fromDataTree(dataTree['input_type_declaration']),
        outputTypeDeclaration: DataItemType.fromDataTree(dataTree['output_type_declaration']),
      )
    );
  }
}
