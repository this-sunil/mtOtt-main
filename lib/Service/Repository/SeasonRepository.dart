import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mtott/Service/model/SeasonModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class SeasonRepository{
  Repository repository=Repository();


  /*Start TV Series Screen Api With Bloc State Management*/
  Future<List<SeasonModel>> fetchSeason(String seriesId,String seasonId) async{
    List<SeasonModel> model=[];
    /*Upcoming TV Shows*/
    repository.init();
    var formData = FormData.fromMap({
      "series_id":seriesId,"season_id":seasonId
    });

    final res=await repository.sendRequest.post(season,data: formData,options: Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    }));
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=seasonModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      debugPrint("Clear model $model");
      for(int i=0;i<data.data.length;i++){
        model.add(SeasonModel(status:data.status, message: data.message, data: data.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;

  }



}