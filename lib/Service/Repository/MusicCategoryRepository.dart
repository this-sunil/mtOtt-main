import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/model/MusicCategoryModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';


/*To Call The Api*/
class MusicCategoryRepository{
  Repository repository=Repository();

  List<MusicCategoryModel> model=[];
  /*Start TV Series Screen Api With Bloc State Management*/
  Future<List<MusicCategoryModel>> fetchMusicCategory() async{
    /*Upcoming TV Shows*/

    repository.init();
    final res=await get(Uri.parse(musicCategory));

    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=musicCategoryModelFromJson(res.body);

    if(res.statusCode==200){
     /* model.clear();
      debugPrint("Music Category clear data ${model.length}");*/
     if(data.musicResponse.isNotEmpty){
       model.clear();
       for(int i=0;i<data.musicResponse.length;i++){
         model.add(MusicCategoryModel(status:data.status, musicResponse: data.musicResponse));
       }
     }
      debugPrint("Music Category data ${model.length}");
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;
  }
}