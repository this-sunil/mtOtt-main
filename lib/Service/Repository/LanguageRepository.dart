import 'package:flutter/material.dart';
import 'package:mtott/Service/model/LanguageModel.dart';
import 'package:mtott/Service/repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../const.dart';

/*To Call The Api*/
class LanguageRepository{
  Repository repository=Repository();
  List<LanguageModel> model=[];

  /*Start Movies Screen Api With Bloc State Management*/
  Future<List<LanguageModel>> fetchLanguage() async{
    /*Upcoming Movies Screen*/
    repository.init();
    final res=await repository.sendRequest.get(language);
    repository.sendRequest.interceptors.add(PrettyDioLogger());
    final data=languageModelFromJson(res.data);

    if(res.statusCode==200){
      model.clear();
      for(int i=0;i<data.data.length;i++){
        model.add(LanguageModel(status:data.status, message: data.message, data: data.data));
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