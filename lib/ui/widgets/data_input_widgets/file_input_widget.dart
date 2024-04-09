import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/file_data.dart';

class FileInputWidget extends StatelessWidget {
  const FileInputWidget({super.key, required this.fileDataInstance});

  final FileData fileDataInstance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FileData>.value(
      value: fileDataInstance,
      child: Consumer<FileData>(
        builder: (context, fileData, child) {
          return Row(
            children: [
              // file path display
              Expanded(
                child: fileData.filepath == null
                    ? const Text('（未选择文件）')
                    : ElevatedButton(
                        onPressed: () {
                          // open file
                          OpenFile.open(fileData.filepath!).then((value) {},
                              onError: (error) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('Failed to open file: $error'),
                                );
                              },
                            );
                          });
                        },
                        child: Text(
                          p.basename(fileData.filepath!),
                        ),
                      ),
              ),
              // pick file button
              // // TODO: hiding the pick file button when the file is being uploaded is a temporary workaround
              // //  We need this to ensure that we have obtained the file ID when the user picks another file,
              // //  so that when it does so, we can use the file ID to send a delete file request to the server.
              // //  Even though we do so, it still doesn't prevent the user from clicking the delete button
              // //  (e.g., if the file is in a list)
              // //  in which case we still cannot signal the server to remove the user's file
              // // fileData.isUploading ? Container() :
              IconButton(
                onPressed: () {
                  FilePicker.platform.pickFiles().then(
                    (value) {
                      if (value != null) {
                        // user picked file
                        fileData.pickFile(value.files.single.path!);
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
                    if (fileData.isUploading) {
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
                          fileData.startUpload(
                            onError: (error) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text(
                                      '文件上传失败: $error'),
                                ),
                              );
                            },
                          );
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
