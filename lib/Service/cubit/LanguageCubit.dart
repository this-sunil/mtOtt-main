import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/LanguageRepository.dart';
import '../model/LanguageModel.dart';
import '../state/LanguageState.dart';

/*Latest Movies Api with Bloc State Management*/
class LanguageCubit extends Cubit<LanguageState>{
  LanguageCubit() : super(LanguageInitialState()) {
    fetchLanguages();
  }
  LanguageRepository languageRepository=LanguageRepository();
  fetchLanguages() async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("Latest Movie with Home Screen Bloc State Management");
    try{
      final List<LanguageModel> slider=await languageRepository.fetchLanguage();
      print("Slider Length $slider");
      emit(LanguageLoadedState(slider));
    }catch(e){
      emit(LanguageErrorState("Error in api $e"));
    }
  }
}