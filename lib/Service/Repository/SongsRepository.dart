import 'package:flutter/material.dart';
import 'package:mtott/Service/repository.dart';
import '../../const.dart';
import '../model/RuningSongModel.dart';
import '../model/UpComingSongsModel.dart';

/*To Call All the Api and Functions*/
class SongsRepository{
  Repository repository=Repository();
  List<UpComingSongModel> model=[];
  List<RuningSongModel> slider=[];
  /*Start Songs Screen Api With Bloc State Management*/
  Future<List<UpComingSongModel>> fetchUpcomingBanner() async{
    /*UpComing Banner With Songs Series Screen*/
    repository.init();
    final res=await repository.sendRequest.get(upcomingSong);
    final result=upComingSongModelFromJson(res.data);
    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<result.data.length;i++){
        model.add(UpComingSongModel(status:result.status, message: result.message, data: result.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
    }
    return model;
  }

 Future<List<RuningSongModel>> fetchRunningBanner() async{
    /*Running Banner With Song Screen*/
    repository.init();
    final res=await repository.sendRequest.get(runningSong);
    final result=runingSongModelFromJson(res.data);

    if(res.statusCode==200){
      slider.clear();
      for(int i=0;i<result.data.length;i++){
        slider.add(RuningSongModel(message: result.message,status: result.status,data: result.data));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
    }
    return slider;
  }

}