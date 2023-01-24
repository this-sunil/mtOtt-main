import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mtott/Service/model/TopPicksModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class TopPicksRepository{
  Repository repository=Repository();
  List<TopPicksModel> model=[];

  /*Start TV Series Screen Api With Bloc State Management*/
  Future<List<TopPicksModel>> fetchTopPick() async{
    /*Upcoming TV Shows*/
    repository.init();
    final res=await get(Uri.parse(topPicks));
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=topPicksModelFromJson(res.body);

    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<data.topPicksResponse.length;i++){
        model.add(TopPicksModel(status:data.status, topPicksResponse: data.topPicksResponse));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode}");
    }
    return model;

  }



}