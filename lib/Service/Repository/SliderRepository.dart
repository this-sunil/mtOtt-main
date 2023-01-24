import 'package:flutter/material.dart';
import 'package:mtott/Service/model/BannerModel.dart';
import 'package:mtott/Service/repository.dart';
import '../../const.dart';
import '../model/RuningHomeModel.dart';

/*To Call All the Api and Functions*/
class SliderRepository{
  Repository repository=Repository();
  List<BannerModel> model=[];
  List<RuningHomeModel> slider=[];
  /*Start Home Screen Api With Bloc State Management*/
  Future<List<BannerModel>> fetchUpcomingBanner() async{
    /*UpComing Banner With Home Screen*/
      repository.init();
      final res=await repository.sendRequest.get(banner);
      final data=bannerModelFromJson(res.data);
      if(res.statusCode==200){
       model.clear();
        for(int i=0;i<data.data.length;i++){
          model.add(BannerModel(status:data.status, message: data.message, data: data.data));
        }
      }
      else{
        debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
      }
      return model;
  }

  Future<List<RuningHomeModel>> fetchRunningBanner() async{
    /*Running Banner With Home Screen*/
    repository.init();
    final res=await repository.sendRequest.get(runningBanner);
    final result=runingHomeModelFromJson(res.data);

    if(res.statusCode==200){
      slider.clear();
      for(int i=0;i<result.data.length;i++){
        slider.add(RuningHomeModel(data: result.data,status: result.status,message: result.message));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
    }
    return slider;
  }



}