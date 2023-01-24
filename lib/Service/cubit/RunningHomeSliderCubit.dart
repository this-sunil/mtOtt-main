import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/model/RuningHomeModel.dart';
import '../Repository/SliderRepository.dart';
import '../state/RuningHomeState.dart';
/*Running Banner Api with Bloc State Management*/
class RunningHomeSliderCubit extends Cubit<RuningHomeState>{
  RunningHomeSliderCubit() : super(InitialState()) {
    fetchBannerSlider();
  }
  SliderRepository sliderRepository=SliderRepository();
  fetchBannerSlider() async{
    /*Runing Banner with Home Screen Bloc State Management*/
    debugPrint("/*Running Banner with Home Screen Bloc State Management*/");
    try{
      final List<RuningHomeModel> slider=await sliderRepository.fetchRunningBanner();
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedStates(slider));
    }catch(e){
      emit(ErrorStates("Error in api $e"));
    }
  }
}