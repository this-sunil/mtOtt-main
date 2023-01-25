import 'dart:collection';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter_svg/svg.dart';

import 'package:mtott/Service/model/Download.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../utility/theme/Database.dart';

import 'SearchScreen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  HashSet<String> item=HashSet<String>();

  DatabaseHelper helper=DatabaseHelper();
  HashSet selectItem=HashSet();
  ReceivePort port = ReceivePort();
  multipleSelection(String title) async{
    if(selectItem.contains(title)){
      selectItem.remove(title);
    }
    else{
      selectItem.add(title);
    }
    setState(() {

    });
  }
  String? taskId;
    DownloadTaskStatus? status;
  int progress=0;
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }
  @override
  void initState() {
    helper.init();
    helper.fetchDownload().then((value){
      debugPrint("Success");
    });

    super.initState();

    IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_send_port');

    port.listen((dynamic data) {
      String id = data[0];
       status = data[1];

      setState((){
        progress = data[2];
        debugPrint("Progress $progress");
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: SvgPicture.asset("asset/logo/leftarrow.svg",color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black)),


        title: Text("Downloads"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ));
          }, icon: SvgPicture.asset("asset/logo/search.svg"))
        ],
      ),
      body:RefreshIndicator(
        onRefresh: () async{
          helper.fetchDownload();
        },
        child: FutureBuilder<List<Download>>(
          future: helper.fetchDownload(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    return Card(

                      child: ListTile(
                        leading: CircleAvatar(
                            maxRadius: 25,
                            backgroundImage: NetworkImage(snapshot.data![index].image)),
                        title: Text(snapshot.data![index].title),
                        subtitle:LinearProgressIndicator(value: progress/100,color: Colors.white),
                        trailing:IconButton(icon: status==DownloadTaskStatus.running?const Icon(Icons.pause_circle):status==DownloadTaskStatus.complete?Icon(Icons.delete_outlined):Icon(Icons.play_circle),onPressed: () async{
                          var stat = await Permission
                              .storage
                              .request();
                          if (stat.isGranted) {
                            final baseStorage =
                            await getExternalStorageDirectory();
                            taskId = await FlutterDownloader.enqueue(
                                url: snapshot.data![index].url,
                                savedDir: baseStorage!.path,
                                openFileFromNotification:
                                true,
                                allowCellular: true,
                                saveInPublicStorage: true,
                                fileName:snapshot.data![index].title,
                                showNotification: true);
                            print("TaskId $taskId ${snapshot.data![index].url}");

                          }
                          if(status==DownloadTaskStatus.undefined){
                              print("hi");

                         }
                         else if(status==DownloadTaskStatus.failed){
                           String? id=await FlutterDownloader.retry(taskId: taskId!);
                           taskId=id;
                         }
                         else if(status==DownloadTaskStatus.running){
                            debugPrint("Task Id $status");
                           await FlutterDownloader.resume(taskId: taskId!).then((value){
                             taskId=value;
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Resume")));
                           });

                         }
                         else if(status==DownloadTaskStatus.complete){
                           debugPrint("Task Id $status");
                            await FlutterDownloader.remove(
                                taskId: taskId!, shouldDeleteContent: true).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remove"))));

                         }
                        }),

                        /*IconButton(onPressed: selectItem.contains(snapshot.data![index].title)?(){
                          helper.removeDownload(snapshot.data![index].index);
                          selectItem.remove(snapshot.data![index].title);
                          setState(() {
                            helper.init();
                          });
                        }:() {


                        },icon:selectItem.contains(snapshot.data![index].title)?const Icon(Icons.delete):Container()),
                        onLongPress: (){
                         multipleSelection(snapshot.data![index].title);
                        },*/
                        onTap: (){
                          FlutterDownloader.open(taskId: taskId.toString());
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>MusicPlayerScreen(index:int.parse(snapshot.data![index].index),title: snapshot.data![index].subtitle,url: "$baseUrl/${snapshot.data![index].url}", subtitle: snapshot.data![index].title)));
                        },
                      ),
                    );

                  });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}


