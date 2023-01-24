import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/LatestChannelRepository.dart';
import '../model/LatestChannelModel.dart';
import '../state/LatestChannelState.dart';

/*Latest Movies Api with Bloc State Management*/
class LatestChannelCubit extends Cubit<LatestChannelState>{
  LatestChannelCubit() : super(LatestChannelInitialState()) {
    fetchLatestChannel();
  }
  LatestChannelRepository latestChannelRepository=LatestChannelRepository();
  fetchLatestChannel() async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("Latest Movie with Home Screen Bloc State Management");
    try{
      final List<LatestChannelModel> slider=await latestChannelRepository.fetchLatestChannel();
      /*print("Slider Length ${slider.length}");*/
      emit(LatestChannelLoadedState(slider));
    }catch(e){
      emit(LatestChannelErrorState("Error in api $e"));
    }
  }
}