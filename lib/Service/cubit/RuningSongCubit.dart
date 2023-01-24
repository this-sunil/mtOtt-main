import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/SongsRepository.dart';
import 'package:mtott/Service/state/RunningSongState.dart';
import '../model/RuningSongModel.dart';
/*Songs Running Banner Api with Bloc State Management*/
class RuningSongCubit extends Cubit<RuningSongState>{
  RuningSongCubit() : super(InitialStates()) {
    fetchBannerSlider();
  }
  SongsRepository songsRepository=SongsRepository();
  fetchBannerSlider() async{
    /*Running Banner with Home Screen Bloc State Management*/
    debugPrint("Songs Running Banner Screen Runing Banner Bloc State Management");
    try{
      final List<RuningSongModel> slider=await songsRepository.fetchRunningBanner();
      print("Songs Length ${slider.length}");
      emit(LoadedStates(slider));
    }catch(e){
      emit(ErrorStates("Error in api $e"));
    }
  }
}