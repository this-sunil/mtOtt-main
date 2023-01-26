import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/model/GenresCategoryModel.dart';
import '../Repository/GenresCategoryRepository.dart';
import '../state/GenresCategoryState.dart';

/*Latest Movies Api with Bloc State Management*/
class GenresCategoryCubit extends Cubit<GenresCategoryState>{
  GenresCategoryCubit() : super(InitialState());
  GenresCategoryRepository genresCategoryRepository=GenresCategoryRepository();
  fetchGenres(String id) async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("Latest Movie with Home Screen Bloc State Management");
    try{
      final List<GenresCategoryModel> slider=await genresCategoryRepository.fetchGenresCategory(id);
      debugPrint("Genres Slider $slider");
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedState(slider));
    }catch(e){
      emit(ErrorState("Error in api $e"));
    }
  }
}