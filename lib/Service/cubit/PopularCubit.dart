import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/PopularRepository.dart';
import 'package:mtott/Service/model/PopularModel.dart';
import '../state/PopularState.dart';

/*Search Screen with Bloc State Management*/
class PopularCubit extends Cubit<PopularState>{
  PopularCubit() : super(InitialPopularState()) {
    fetchGenres();
  }
  PopularRepository popularRepository=PopularRepository();
  fetchGenres() async{
    /*Search  Screen Bloc State Management*/
    debugPrint("Search Screen Bloc State Management");
    try{
      final List<PopularModel> slider=await popularRepository.fetchPopular();
      debugPrint("Popular Search data $slider");
      emit(LoadedPopularState(slider));
    }catch(e){
      emit(ErrorPopularState("Error in api $e"));
    }
  }
}