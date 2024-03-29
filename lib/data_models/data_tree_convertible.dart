/// Represents an object that can be serialized to a data tree
abstract class DataTreeSerializable {
  /// Serializes `self` to a data tree.
  dynamic toDataTree();
}

/// Represents an object that can be deserialized from a data tree
abstract class DataTreeDeserializable {
  /// Creates a `Self` from the data tree.
  static dynamic fromDataTree(dynamic dataTree) {
    throw UnimplementedError();
  }
}