import 'package:flutter/foundation.dart';
import 'package:async/async.dart';

import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';

class FileData extends ChangeNotifier {
  FileData({String? filepath, String? fileID})
      : _filepath = filepath,
        _fileID = fileID;

  String? _filepath;
  String? _fileID;
  CancelableOperation<void>? _uploadOperation;
  CancelableOperation<void>? _downloadOperation;

  bool get isUploading =>
      _uploadOperation != null &&
      !_uploadOperation!.isCanceled &&
      !_uploadOperation!.isCompleted;

  bool get isDownloading =>
      _downloadOperation != null &&
      !_downloadOperation!.isCanceled &&
      !_downloadOperation!.isCompleted;

  String? get filepath => _filepath;

  String? get fileID => _fileID;

  void startUpload({void Function(Object)? onError}) {
    assert(_filepath != null && _fileID == null);

    _uploadOperation = CancelableOperation.fromFuture(
        _uploadFile(_filepath!).then((fileID) {
          // when the file finishes uploading,
          // assign the file ID only if the operation was not cancelled.
          if (!_uploadOperation!.isCanceled) {
            _fileID = fileID;
          }
        }, onError: onError).whenComplete(() {
          // when the upload operation finishes or fails,
          // notify listeners
          notifyListeners();
        }), onCancel: () {
      // when the operation gets canceled, notify listeners
      notifyListeners();
    });

    // when the upload operation starts, notify listeners
    notifyListeners();
  }

  void startDownload({void Function(Object)? onError}) {
    assert(_fileID != null && _filepath == null);

    _downloadOperation = CancelableOperation.fromFuture(
        _downloadFile(_fileID!).then((filepath) {
          // when the file finishes downloading,
          // assign the file path only if
          // the download operation is not cancelled
          if (!_downloadOperation!.isCanceled) {
            _filepath = filepath;
          }
        }, onError: onError).whenComplete(() {
          // when the download operation finishes or fails,
          // notify listeners
          notifyListeners();
        }), onCancel: () {
      // when the operation gets canceled, notify listeners
      notifyListeners();
    });

    // when the download operation starts, notify listeners
    notifyListeners();
  }

  /// Assigns a new file, invalidating the old file ID.
  ///
  /// If an upload is in progress, this will cancel file uploading operation
  /// (on client side; not sure what happens on the server side).
  void pickFile(String filepath) {
    // first cancel the ongoing uploading operation, if any
    if (_uploadOperation != null) {
      _uploadOperation!.cancel();
    }

    // TODO: if a file ID is already obtained,
    //  use it to send a delete file request to the server

    // set the filepath and invalidate the file ID
    _filepath = filepath;
    _fileID = null;

    // notify listeners
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
      throw Exception(
          "Attempting to serialize file data before file ID is assigned; this error typically occurs because you did not upload the file to the server or did not assign the returned file ID.");
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

  Future<String> _uploadFile(String filepath) async {
    return (await BackendClient.uploadFile(
            FileUploadRequest(filepath: filepath)))
        .fileID;
  }

  Future<String> _downloadFile(String fileID) async {
    return (await BackendClient.downloadFile(
            FileDownloadRequest(fileID: fileID)))
        .filepath;
  }
}
