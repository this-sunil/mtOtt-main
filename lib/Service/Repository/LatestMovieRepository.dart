import 'package:flutter/material.dart';
import 'package:mtott/Service/model/LatestMoviesModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class LatestMovieRepository{
  Repository repository=Repository();
  List<LatestMoviesModel> model=[];

  /*Start Movies Screen Api With Bloc State Management*/
  Future<List<LatestMoviesModel>> fetchMovieSlider() async{
    /*Upcoming Movies Screen*/
    repository.init();
    final res=await repository.sendRequest.get(latestMovie);
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=latestMoviesModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<data.data.length;i++){
        model.add(LatestMoviesModel(status:data.status, message: data.message, data: data.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;
    /*Upcoming Movies Screen*/
  }
  /*End Movies Screen Api With Bloc State Management!!!*/


}