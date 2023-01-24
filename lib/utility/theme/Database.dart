import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../Service/model/Download.dart';
import '../../Service/model/Music.dart';

class DatabaseHelper{
  late Database database;
  Future<Database> init() async{

    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "Databases.db");
    Database db=await openDatabase(dbPath,version: 1,onCreate: create);
    return db;

  }
  create(Database db,int version) async{
    await db.execute("""CREATE TABLE Music(id INTEGER PRIMARY KEY,currentID TEXT,title TEXT,image TEXT,url TEXT,subtitle TEXT)""");
    await db.execute("""CREATE TABlE Download(id INTEGER PRIMARY KEY,currentId TEXT,url TEXT,title TEXT,description TEXT,seasonId TEXT,type TEXT,imgPath TEXT,seriesId TEXT)""");
  }

  addFav(String index,String title,String image,String url,String subtitle) async{
    database=await init();
    database.insert("Music", {"currentID":index,"title":title,"image":image,"url":url,"subtitle":subtitle}).then((value) => debugPrint("Music  added Successfully"));
  }
  removeFav(String title) async{
    database=await init();
    database.delete("Music",where: "title=?",whereArgs: [title]).then((value) => debugPrint("Music remove Successfully"));
  }
  addDownload(String id,String title,String url,String description,String seasonId,String imgPath,String seriesId,String type) async{
    database=await init();
    database.insert("Download", {"currentId":id,"url":url,"title":title,"description":description,"seasonId":seasonId,"type":type,"imgPath":imgPath,"seriesId":seriesId});
  }
  removeDownload(String id) async{
    database=await init();
    database.delete("Download",where: "currentId=?",whereArgs: [id]).then((value) => debugPrint("Download remove Successfully"));
  }
  Future<List<Download>> fetchDownload() async {
    database=await init();
    List<Map<String,dynamic>> results = await database.query("Download",columns: ["currentId","title","url","description","seasonId","imgPath","seriesId"],distinct: true);

    List<Download> download=[];
    if(results.isNotEmpty) {
      debugPrint("Download Data");
      results.map((e){
        download.add(Download(index:e["currentId"],title: e["title"], image: e["imgPath"],url:e["url"], description: e["description"], seriesId: e["seriesId"], seasonId: e["seasonId"]));
      }).toList();
    }
    return download;
  }
  Future<List<Music>> fetchFav() async {
    database=await init();
    List<Map<String,dynamic>> results = await database.query("Music",columns: ["currentID","title","image","url","subtitle"]);

    List<Music> fav=[];
    if(results.isNotEmpty) {
      debugPrint("Music Data");
      results.map((e){
        fav.add(Music(index:e["currentID"],title: e["title"], image: e["image"],url:e["url"], subtitle: e["subtitle"]));
      }).toList();
    }
    return fav;
  }
}