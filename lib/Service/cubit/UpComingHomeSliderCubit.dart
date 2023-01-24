import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/SliderRepository.dart';
import 'package:mtott/Service/model/BannerModel.dart';
import '../../Service/state/UpComingHomeSliderState.dart';
/*Upcoming Banner with Home Screen Bloc State Management*/
/*Running Banner with Home Screen Bloc State Management*/
class UpComingHomeSliderCubit extends Cubit<UpComingHomeSliderState>{
  UpComingHomeSliderCubit() : super(InitialState()) {
    fetchSlider();
  }
  SliderRepository sliderRepository=SliderRepository();
  fetchSlider() async{
    /*Upcoming Banner with Home Screen Bloc State Management*/
    debugPrint("Upcoming Banner with Home Screen Bloc State Management");
    try{
      final List<BannerModel> slider=await sliderRepository.fetchUpcomingBanner();
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedState(slider));
    }catch(e){
      emit(ErrorState("Error in api $e"));
    }
  }

}