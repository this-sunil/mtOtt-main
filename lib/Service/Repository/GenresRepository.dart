import 'package:flutter/material.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';
import '../model/GenresModel.dart';

/*To Call The Api*/
class GenresRepository{
  Repository repository=Repository();
  List<GenresModel> model=[];

  /*Start Movies Screen Api With Bloc State Management*/
  Future<List<GenresModel>> fetchGenres() async{
    /*Upcoming Home Screen for Generes Api*/
    repository.init();
    final res=await repository.sendRequest.get(genres);
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=genresModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<data.data.length;i++){
        model.add(GenresModel(status:data.status, message: data.message, data: data.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;
  }



}