import 'package:flutter/foundation.dart';

import 'data_items/data_item.dart';
import 'primitives/integer_data.dart';
import 'primitives/string_data.dart';

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
