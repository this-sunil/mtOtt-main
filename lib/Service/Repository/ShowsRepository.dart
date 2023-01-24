import 'package:flutter/material.dart';
import 'package:mtott/Service/model/ShowsModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class ShowsRepository{
  Repository repository=Repository();
  List<ShowsModel> model=[];

  /*Start TV Series Screen Api With Bloc State Management*/
  Future<List<ShowsModel>> fetchShows() async{
    /*Upcoming TV Shows*/
    repository.init();
    final res=await repository.sendRequest.get(shows);
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=showsModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<data.data.length;i++){
        model.add(ShowsModel(status:data.status, message: data.message, data: data.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;

  }



}