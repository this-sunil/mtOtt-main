import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mtott/utility/theme/Database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import 'MyItems.dart';
class MyDownload extends StatefulWidget {
  final TargetPlatform? platform;

  const MyDownload({super.key, this.platform});

  @override
  _MyDownloadState createState() => _MyDownloadState();
}

class _MyDownloadState extends State<MyDownload> {
  ReceivePort _port = ReceivePort();
  late bool _isLoading;
  late bool _permissionReady;
  late String _localPath;
  late List<MyItem> itemsList;
  DatabaseHelper helper=DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _isLoading = true;
    _permissionReady = false;
    _prepare();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      /*
       Update UI with the latest progress
       */
      String? id = data[0];
      DownloadTaskStatus? status = data[1];
      int progress = data[2];

      if (itemsList.isNotEmpty) {
        final item = itemsList.firstWhere((it) => it.itemID == id);
        setState(() {
          item.status = status;
          item.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status,
      int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<Null> _prepare() async {

    itemsList = [];
    helper.fetchDownload().then((value) => itemsList.addAll(value.map((e) => MyItem(image: e.image, name: e.title, url: e.url)).toList()));

    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) return true;


    if (widget.platform == TargetPlatform.android )
      // && androidInfo.version.sdkInt! <= 28)
        {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await PathProviderAndroid().getDownloadsPath(); //AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Download'),
        ),
        body: Builder(
          builder: (context) =>
          _isLoading
              ?  Center(child: new CircularProgressIndicator(),)
              : _permissionReady ?
          ListView(
              children: itemsList.map((it) =>
                  DownloadItem(
                      myItem: it,
                      openItem: (myItem)
                      {
                        _openDownloadedFile(myItem).then((success) {
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Cannot open this file')));
                          }
                        });
                      },
                      onActionClick: (myItem) async{
                        if (myItem.status == DownloadTaskStatus.undefined) {
                          myItem.itemID = await FlutterDownloader.enqueue(
                            url: myItem.url,
                            savedDir: _localPath,
                            showNotification: true,
                            fileName: myItem.name,
                            openFileFromNotification: true,
                            saveInPublicStorage: true,
                          );
                          //_requestDownload(myItem);
                        }
                        else if (myItem.status == DownloadTaskStatus.running) {
                          await FlutterDownloader.pause(taskId: myItem.itemID!);
                          pauseDownload(myItem);
                        }
                        else if (myItem.status == DownloadTaskStatus.paused) {
                          String? newTaskId = await FlutterDownloader.resume(taskId: myItem.itemID!);
                          myItem.itemID = newTaskId;
                          resumeDownload(myItem);
                        }
                        else if (myItem.status == DownloadTaskStatus.complete) {
                          await FlutterDownloader.remove(
                              taskId: myItem.itemID!, shouldDeleteContent: true);
                          await _prepare();
                          setState(() {});
                          delete(myItem);
                        }
                        else if (myItem.status == DownloadTaskStatus.failed) {
                          String? newTaskId = await FlutterDownloader.retry(taskId: myItem.itemID!);
                          myItem.itemID = newTaskId;

                          //retryDownload(myItem);
                        }
                      }
                  ),).toList())
              :
          Container(),
        ));
  }

  Future<bool> _openDownloadedFile(MyItem item) {
    if (item != null) {
      return FlutterDownloader.open(taskId: item.itemID!);
    } else {
      return Future.value(false);
    }
  }

  void requestDownload(MyItem item) async {
    item.itemID = await FlutterDownloader.enqueue(
      url: item.url,
      savedDir: _localPath,
      showNotification: true,
      fileName: item.name,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
  }

  void pauseDownload(MyItem item) async {
    await FlutterDownloader.pause(taskId: item.itemID!);
  }

  void retryDownload(MyItem item) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: item.itemID!);
    item.itemID = newTaskId;
  }

  void resumeDownload(MyItem item) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: item.itemID!);
    item.itemID = newTaskId;
  }
  void delete(MyItem item) async {
    await FlutterDownloader.remove(
        taskId: item.itemID!, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }
}
class DownloadItem extends StatelessWidget {
  final MyItem myItem;
  final Function(MyItem) openItem;
  final Function(MyItem) onActionClick;
  const DownloadItem(
      {required this.myItem,
        required this.openItem,
        required this.onActionClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: myItem.status == DownloadTaskStatus.complete
          ? () {
        openItem(myItem);
      }
          : null,
      child: Card(

        child: ListTile(
          leading:  CircleAvatar(
              maxRadius:25,
              backgroundImage: NetworkImage(myItem.image)),
          title:  Text(myItem.name),
          subtitle: FAProgressBar(
            direction: Axis.horizontal,
            size: 4,
            progressColor: Colors.amber,
            maxValue:100.0,

            changeProgressColor: Colors.amberAccent,
            borderRadius: BorderRadius.circular(5),

            backgroundColor: Colors.white,
            currentValue: myItem.progress==100?100:myItem.progress%100,
          ),
          trailing:  Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildActionForTask(myItem),
          ),
        ),


      ),
    );
  }

  Widget? _buildActionForTask(MyItem item) {
    if (item.status == DownloadTaskStatus.undefined) {
      return RawMaterialButton(
        onPressed: () {
          onActionClick(item);


        },
        child: Icon(Icons.file_download_outlined),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    }
    else if (item.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          onActionClick(item);
        },
        child: Icon(
          Icons.pause_circle,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    }
    else if (item.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          onActionClick(item);
        },
        child: Icon(
          Icons.play_circle,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    }
    else if (item.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          RawMaterialButton(
            onPressed: () {
              onActionClick(item);
              DatabaseHelper helper=DatabaseHelper();
              helper.removeDownload(myItem.name);
              helper.fetchDownload();

            },
            child: Icon(
              Icons.delete_outlined,
              color: Colors.white,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    }

    else if (item.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              onActionClick(item);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    }
    else if (item.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    }

    else if (item.status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Colors.orange));
    }
    else {
      return null;
    }
  }
}