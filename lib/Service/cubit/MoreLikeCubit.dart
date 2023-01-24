import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/MoreLikeRepository.dart';
import 'package:mtott/Service/model/MoreLikeModel.dart';
import 'package:mtott/Service/state/MoreLikeState.dart';
/*Latest Movies Api with Bloc State Management*/
class MoreLikeCubit extends Cubit<MoreLikeState>{
  MoreLikeCubit() : super(InitialState());
  MoreLikeRepository moreLikeRepository=MoreLikeRepository();
  fetchMoreLike(String movieId) async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("Latest Movie with Home Screen Bloc State Management");
    try{
      final List<MoreLikeModel> slider=await moreLikeRepository.fetchMoreLike(movieId);
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedState(slider));
    }catch(e){
      emit(ErrorState("Error in api $e"));
    }
  }
}