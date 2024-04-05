import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/file_data.dart';

class FileDisplayWidget extends StatefulWidget {
  const FileDisplayWidget({super.key, required this.fileDataInstance});

  final FileData fileDataInstance;

  @override
  State<FileDisplayWidget> createState() => _FileDisplayWidgetState();
}

class _FileDisplayWidgetState extends State<FileDisplayWidget> {
  bool isDownloadingFile = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FileData>.value(
      value: widget.fileDataInstance,
      child: Consumer<FileData>(
        builder: (context, fileData, child) {
          return Row(
            children: [
              // file path display
              Expanded(
                child: Text(
                  fileData.filepath == null
                      ? ''
                      : p.basename(fileData.filepath!),
                ),
              ),
              Builder(
                builder: (context) {
                  if (fileData.filepath != null) {
                    // file downloaded
                    return const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text('已下载'),
                      ],
                    );
                  } else {
                    // file not downloaded or is being downloaded
                    if (isDownloadingFile) {
                      // file downloading
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LoadingAnimationWidget.discreteCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const Text('下载中...'),
                        ],
                      );
                    } else {
                      // file not downloading and not downloaded
                      return IconButton(
                        onPressed: () {
                          // download file
                          BackendClient.downloadFile(
                                  FileDownloadRequest(fileID: fileData.fileID!))
                              .then(
                            (value) {
                              // file downloaded successfully
                              fileData.assignDownloadedFilepath(value.filepath);
                            },
                            onError: (error) {
                              // error occurred when uploading file
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        'Error occurred when downloading file: $error'),
                                  );
                                },
                              );
                            },
                          ).whenComplete(
                            () {
                              setState(() {
                                isDownloadingFile = false;
                              });
                            },
                          );

                          setState(() {
                            isDownloadingFile = true;
                          });
                        },
                        icon: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.download),
                            Text('下载文件'),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
