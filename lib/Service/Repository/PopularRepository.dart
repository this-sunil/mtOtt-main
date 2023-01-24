import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/model/ShowsModel.dart';
import 'package:mtott/Service/model/PopularModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class PopularRepository{
  Repository repository=Repository();
  List<PopularModel> model=[];

  /*Start Search Screen Api With Bloc State Management*/
  Future<List<PopularModel>> fetchPopular() async{
    /*Search screen*/
    repository.init();
    final res=await get(Uri.parse(popularApi));
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final result=popularModelFromJson(res.body);

    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<result.data.length;i++){
        model.add(PopularModel(status:result.status,message: result.message, data: result.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.request!.url}");
    }
    return model;

  }



}