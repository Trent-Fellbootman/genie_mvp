class FileUploadRequest {
  const FileUploadRequest({required this.filepath});

  final String filepath;
}

class FileUploadResponse {
  const FileUploadResponse({required this.fileID});

  final String fileID;
}

class FileDownloadRequest {
  const FileDownloadRequest({required this.fileID});

  final String fileID;
}

class FileDownloadResponse {
  const FileDownloadResponse({required this.filepath});

  final String filepath;
}
