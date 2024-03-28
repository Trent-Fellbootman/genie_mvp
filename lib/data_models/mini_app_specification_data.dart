import 'package:flutter/foundation.dart';

import 'mini_app_data_items/data_item.dart';
import 'data_types/integer_data.dart';
import 'data_types/string_data.dart';

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
    required this.name,
    required this.likes,
    required this.dislikes,
    required this.description,
  });

  final String name;
  final IntegerData likes;
  final IntegerData dislikes;
  final String description;
}

class MiniAppSpecification {
  MiniAppSpecification({
    required this.inputOutputSpecification,
    required this.metadata,
  });

  final MiniAppInputOutputSpecification inputOutputSpecification;
  final MiniAppSpecificationMetadata metadata;
}
