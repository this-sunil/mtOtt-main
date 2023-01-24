import 'package:flutter/material.dart';
import 'package:mtott/Service/model/MusicCategoryTypeModel.dart';
import 'package:mtott/Service/model/MusicCategoryTypeModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';
import 'package:dio/dio.dart';

/*To Call The Api*/
class MusicCategoryTypeRepository{
  Repository repository=Repository();

  List<MusicCategoryTypeModel> model=[];
  /*Start Music sub Category Screen Api With Bloc State Management*/
  Future<List<MusicCategoryTypeModel>> fetchMusicCategory(String musicType) async{

    /*Upcoming TV Shows*/

    repository.init();
    var formData = FormData.fromMap({
      "music_type":musicType,
    });
    final res=await repository.sendRequest.post(musicCategoryType,data: formData);
    repository.sendRequest.interceptors.add(PrettyDioLogger());

    final result=musicCategoryTypeModelFromJson(res.data);
    if(res.statusCode==200){
      model.clear();
      debugPrint("Music Category Type ${musicType}");
      if(result.data.isNotEmpty){

        result.data.map((e) =>  model.add(MusicCategoryTypeModel(status:result.status, message: result.message, data: result.data))).toList();
      }


    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;
  }

}