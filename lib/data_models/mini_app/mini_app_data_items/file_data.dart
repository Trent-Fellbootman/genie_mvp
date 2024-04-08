import 'package:flutter/foundation.dart';

class FileData extends ChangeNotifier {
  FileData({String? filepath, String? fileID})
      : _filepath = filepath,
        _fileID = fileID;

  String? _filepath;
  String? _fileID;

  String? get filepath => _filepath;

  /// Assigns a new file, invalidating the file ID.
  void setPickedFilePath(String filepath) {
    _filepath = filepath;
    _fileID = null;
    notifyListeners();
  }

  String? get fileID => _fileID;

  /// Assigns the fileID returned by the server.
  ///
  /// Call this method when the file finishes uploading to the server.
  void assignUploadedFileID(String fileID) {
    _fileID = fileID;
    notifyListeners();
  }

  /// Assigns the filepath returned by the server.
  void assignDownloadedFilepath(String filepath) {
    _filepath = filepath;
    notifyListeners();
  }

  /// Sets the file ID to null.
  void invalidateFileID() {
    _fileID = null;
    notifyListeners();
  }

  @override
  String toString() {
    return 'FileData{filepath: $_filepath, fileID: $_fileID}';
  }

  // TODO: the semantics of this method are completely for server-side,
  //  as it only serializes the file ID.
  dynamic serializeDataToDataTree() {
    if (_fileID == null) {
      throw Exception("Attempting to serialize file data before file ID is assigned; this error typically occurs because you did not upload the file to the server or did not assign the returned file ID.");
    }
    return _fileID!;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileData && _fileID == other._fileID;
  }

  @override
  int get hashCode => _filepath.hashCode ^ _fileID.hashCode;
}
