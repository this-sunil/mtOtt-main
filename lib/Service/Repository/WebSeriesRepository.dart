import 'package:flutter/material.dart';
import 'package:mtott/Service/model/RuningWebSeriesModel.dart';
import 'package:mtott/Service/model/WebSeriesModel.dart';
import 'package:mtott/Service/repository.dart';
import '../../const.dart';

/*To Call All the Api and Functions*/
class WebSeriesRepository{
  Repository repository=Repository();
  List<WebSeriesModel> model=[];
  List<RunningWebSeriesModel> slider=[];
  /*Start Home Screen Api With Bloc State Management*/
  Future<List<WebSeriesModel>> fetchUpcomingBanner() async{
    /*UpComing Banner With Web Series Screen*/
    repository.init();
    final res=await repository.sendRequest.get(upcomingSeries);
    final result=webSeriesModelFromJson(res.data);
    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<result.data.length;i++){
        model.add(WebSeriesModel(status:result.status, message: result.message, data: result.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
    }
    return model;
  }

  Future<List<RunningWebSeriesModel>> fetchRunningBanner() async{
    /*Running Banner With WebSeries Screen*/
    repository.init();
    final res=await repository.sendRequest.get(runningSeries);
    final result=runningWebSeriesModelFromJson(res.data);

    if(res.statusCode==200){
      slider.clear();
      for(int i=0;i<result.data.length;i++){
        slider.add(RunningWebSeriesModel(message: result.message,status: result.status,data: result.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
    }
    return slider;
  }

}