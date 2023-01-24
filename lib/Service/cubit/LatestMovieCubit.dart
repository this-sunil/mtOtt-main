import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/model/LatestMoviesModel.dart';
import 'package:mtott/Service/state/LatestMoviesState.dart';
import '../Repository/LatestMovieRepository.dart';
/*Latest Movies Api with Bloc State Management*/
class LatestMovieCubit extends Cubit<LatestMovieState>{
  LatestMovieCubit() : super(LatestMovieInitialState()) {
    fetchLatestMovie();
  }
  LatestMovieRepository latestMovieRepository=LatestMovieRepository();
  fetchLatestMovie() async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("Latest Movie with Home Screen Bloc State Management");
    try{
      final List<LatestMoviesModel> slider=await latestMovieRepository.fetchMovieSlider();
      /*print("Slider Length ${slider.length}");*/
      emit(LatestMovieLoadedState(slider));
    }catch(e){
      emit(LatestMovieErrorState("Error in api $e"));
    }
  }
}