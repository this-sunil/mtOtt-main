import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/MusicCategoryRepository.dart';
import '../model/MusicCategoryModel.dart';
import '../state/MusicCategoryState.dart';
/*Latest Movies Api with Bloc State Management*/
class MusicCategoryCubit extends Cubit<MusicCategoryState>{
  MusicCategoryCubit() : super(MusicCategoryInitialState());
  MusicCategoryRepository musicCategoryRepository=MusicCategoryRepository();
  fetchMusicCategory() async{

    debugPrint("Music Category Screen Bloc State Management");
    try{
      final List<MusicCategoryModel> slider=await musicCategoryRepository.fetchMusicCategory();
      print("Music Category Length ${slider.length}");
      emit(MusicCategoryLoadedState(slider));
   }catch(e){
      emit(MusicCategoryErrorState("Error in api $e"));
    }
  }
}