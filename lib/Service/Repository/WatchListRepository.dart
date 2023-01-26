import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/model/WatchListModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class WatchListRepository{
  Repository repository=Repository();


  /*Start TV Series Screen Api With Bloc State Management*/
  Future<List<WatchListModel>> fetchWatchList(String userId) async{
    /*Upcoming TV Shows*/
    List<WatchListModel> model=[];
    repository.init();
    final res=await post(Uri.parse(seeWatchList),body: {"userid":userId});
    debugPrint("Response ${res.body}");
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final result=watchListModelFromJson(res.body);
    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<result.data.length;i++){
        model.add(WatchListModel(status:result.status, data: result.data, message: result.message));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;
  }
}