import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/state/MusicCategoryTypeState.dart';
import '../Repository/MusicCategoryTypeRepository.dart';
import '../model/MusicCategoryTypeModel.dart';

/*Latest Movies Api with Bloc State Management*/
class MusicCategoryTypeCubit extends Cubit<MusicCategoryTypeState>{
  MusicCategoryTypeCubit() : super(MusicCategoryTypeInitialState());
  MusicCategoryTypeRepository musicCategoryTypeRepository=MusicCategoryTypeRepository();

  fetchMusicCategoryType(String musicType) async{


    debugPrint("Music Sub Category Screen Bloc State Management");
    try{

      final List<MusicCategoryTypeModel> slider=await musicCategoryTypeRepository.fetchMusicCategory(musicType);
      print("Slider Sub Category music Length ${slider.length}");
      emit(MusicCategoryTypeLoadedState(slider));

    }catch(e){
      emit(MusicCategoryTypeErrorState("Error in api $e"));
    }
  }
}