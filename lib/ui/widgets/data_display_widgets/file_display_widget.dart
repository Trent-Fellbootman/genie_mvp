import 'package:flutter/material.dart';
import 'package:genie_mvp/backend/backend_client.dart';
import 'package:genie_mvp/data_models/backend_api/file_operations.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';

import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/file_data.dart';

class FileDisplayWidget extends StatelessWidget {
  const FileDisplayWidget({super.key, required this.fileDataInstance});

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
                    ? Container()
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
                    if (fileData.isDownloading) {
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
                          fileData.startDownload(
                            onError: (error) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text('下载文件失败: $error'),
                                ),
                              );
                            },
                          );
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
