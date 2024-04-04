import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/file_data.dart';

class FileInputWidget extends StatefulWidget {
  const FileInputWidget({super.key, required this.fileDataInstance});

  final FileData fileDataInstance;

  @override
  State<FileInputWidget> createState() => _FileInputWidgetState();
}

class _FileInputWidgetState extends State<FileInputWidget> {
  bool isUploadingFile = false;

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
                      ? '（未选择文件）'
                      : p.basename(fileData.filepath!),
                ),
              ),
              // upload button
              IconButton(
                onPressed: () {
                  FilePicker.platform.pickFiles().then(
                    (value) {
                      if (value != null) {
                        // user picked file
                        fileData.setPickedFilePath(value.files.single.path!);
                      } else {
                        // user did not pick file; do nothing
                      }
                    },
                    onError: (error) {
                      // error occurred
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content:
                              Text('Error occurred when picking file: $error'),
                        ),
                      );
                    },
                  );
                },
                icon: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_open),
                    Text('选择文件'),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (fileData.filepath == null) {
                    // no file selected
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    );
                  } else if (fileData.fileID == null) {
                    if (isUploadingFile) {
                      // file uploading
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LoadingAnimationWidget.discreteCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const Text('上传中...'),
                        ],
                      );
                    } else {
                      // file selected but not uploaded nor uploading
                      // return file upload button
                      return IconButton(
                        onPressed: () {
                          // upload file
                          BackendClient.uploadFile(FileUploadRequest(
                                  filepath: fileData.filepath!))
                              .then(
                            (value) {
                              // file uploaded successfully
                              fileData.assignUploadedFileID(value.fileID);
                            },
                            onError: (error) {
                              // error occurred when uploading file
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        'Error occurred when uploading file: $error'),
                                  );
                                },
                              );
                            },
                          ).whenComplete(
                            () {
                              setState(() {
                                isUploadingFile = false;
                              });
                            },
                          );

                          setState(() {
                            isUploadingFile = true;
                          });
                        },
                        icon: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.upload),
                            Text('上传文件'),
                          ],
                        ),
                      );
                    }
                  } else {
                    // file uploaded
                    // return file uploaded indicator
                    return const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text('已上传'),
                      ],
                    );
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
