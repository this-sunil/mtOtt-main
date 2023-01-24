import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';
import '../model/GenresCategoryModel.dart';

/*To Call The Api*/
class GenresCategoryRepository{
  Repository repository=Repository();


  /*Genres category eg.action,drama,comedy Home Screen Api With Bloc State Management*/
  Future<List<GenresCategoryModel>> fetchGenresCategory(String id) async{
    List<GenresCategoryModel> model=[];
    repository.init();
    final res=await repository.sendRequest.post(genresCategory,data: FormData.fromMap(
        {"genre_id":id}));
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final result=genresCategoryModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      if(result.data.isNotEmpty){
        for(int i=0;i<result.data.length;i++){
          model.add(GenresCategoryModel(status:result.status, message: result.message, data: result.data));
        }
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;
  }



}