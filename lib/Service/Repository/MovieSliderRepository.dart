import 'package:flutter/material.dart';
import 'package:mtott/Service/model/BannerModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';
import '../model/RuningMovieModel.dart';

/*To Call The Api*/
class MovieSliderRepository{
  Repository repository=Repository();
  List<BannerModel> model=[];
  List<RuningMovieModel> slider=[];
  /*Start Movies Screen Api With Bloc State Management*/
  Future<List<BannerModel>> fetchMovieSlider() async{
    /*Upcoming Movies Screen*/
      repository.init();
      final res=await repository.sendRequest.get(movieBanner);
      repository.sendRequest.interceptors.add(PrettyDioLogger());
      final data=bannerModelFromJson(res.data);

      if(res.statusCode==200){
       model.clear();
        for(int i=0;i<data.data.length;i++){
          model.add(BannerModel(status:data.status, message: data.message, data: data.data));
        }
      }
      else{
        debugPrint("Error in api Status Code ${res.statusCode}");
      }
      return model;
    /*Upcoming Movies Screen*/
  }
  /*End Movies Screen Api With Bloc State Management!!!*/

  Future<List<RuningMovieModel>> fetchMovieBanner() async{
    /*Running Banner With Movie Screen*/
    repository.init();
    final res=await repository.sendRequest.get(runningMovies);
    final result=runingMovieModelFromJson(res.data);

    if(res.statusCode==200){
      slider.clear();
      for(int i=0;i<result.data.length;i++){
        slider.add(RuningMovieModel(data: result.data,status: result.status,message: result.message));
      }
    }
    else{
      debugPrint("Error in api Status Code ${res.statusCode} and ${res.realUri.path}");
    }
    return slider;
  }
}