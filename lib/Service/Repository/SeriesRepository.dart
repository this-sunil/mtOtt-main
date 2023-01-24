import 'package:flutter/material.dart';
import 'package:mtott/Service/model/SeriesModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';
import 'package:dio/dio.dart';

/*To Call The Api*/
class SeriesRepository{
  Repository repository=Repository();


  /*Start TV Series Screen Api With Bloc State Management*/
  Future<List<SeriesModel>> fetchSeries(String seriesId) async{
    List<SeriesModel> model=[];
    /*Upcoming TV Shows*/
    repository.init();
    var formData = FormData.fromMap({
      "series_id":seriesId
    });
    final res=await repository.sendRequest.post(series,data: formData);
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final result=seriesModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      if(result.data.isNotEmpty){
        for(int i=0;i<result.data.length;i++){
          model.add(SeriesModel(status:result.status, message: result.message, data: result.data));
        }
      }
      else {
        debugPrint("result is Empty ${result.data.length}");
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;

  }



}