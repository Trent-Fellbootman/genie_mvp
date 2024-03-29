import 'package:flutter/foundation.dart';

import 'mini_app_data_items/data_item.dart';
import 'data_types/integer_data.dart';

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
    required this.likes,
    required this.dislikes,
  });

  final String miniAppID;
  final String name;
  final String description;
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
}
