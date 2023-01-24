import 'package:dio/dio.dart';
import 'package:mtott/Service/model/MoreLikeModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:mtott/const.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MoreLikeRepository{
  Repository repository=Repository();

  Future<List<MoreLikeModel>> fetchMoreLike(String movieId) async{
    List<MoreLikeModel> moreLike=[];
    repository.init();
    var formData = FormData.fromMap({
      "movie_id":movieId,
    });

    final resp=await repository.sendRequest.post(moreLikeApi,data: formData);
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final result=moreLikeModelFromJson(resp.data);
    if(resp.statusCode==200){
      moreLike.clear();
      if(result.data.isNotEmpty){
        for(int i=0;i<result.data.length;i++){
          moreLike.add(MoreLikeModel(status: result.status, message: result.message, data: result.data));
        }
      }
    }
    return moreLike;
  }
}