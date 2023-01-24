import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/GenresRepository.dart';
import '../model/GenresModel.dart';
import '../state/GenresState.dart';

/*Latest Movies Api with Bloc State Management*/
class GenresCubit extends Cubit<GenresState>{
  GenresCubit() : super(GenresInitialState()) {
    fetchGenres();
  }
  GenresRepository genresRepository=GenresRepository();
  fetchGenres() async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("Latest Movie with Home Screen Bloc State Management");
    try{
      final List<GenresModel> slider=await genresRepository.fetchGenres();
      debugPrint("Genres Slider $slider");
      /*print("Slider Length ${slider.length}");*/
      emit(GenresLoadedState(slider));
    }catch(e){
      emit(GenresErrorState("Error in api $e"));
    }
  }
}