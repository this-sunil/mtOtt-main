import 'package:flutter_downloader/flutter_downloader.dart';

class MyItem {
  final String name, url,image;
  String? itemID;
  int progress =0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  MyItem({required this.image,required this.name, required this.url});

}