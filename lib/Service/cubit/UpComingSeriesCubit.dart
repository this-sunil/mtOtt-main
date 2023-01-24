import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/WebSeriesRepository.dart';
import 'package:mtott/Service/model/WebSeriesModel.dart';

import '../state/UpComingSeriesState.dart';


/*Upcoming Banner with Web Screen Bloc State Management*/
class UpComingSeriesSliderCubit extends Cubit<UpComingSeriesState>{
  UpComingSeriesSliderCubit() : super(initialState()) {
    fetchSlider();
  }
  WebSeriesRepository sliderRepository=WebSeriesRepository();
  fetchSlider() async{
    debugPrint("Upcoming Banner with Web Screen Bloc State Management");
    try{
      final List<WebSeriesModel> slider=await sliderRepository.fetchUpcomingBanner();
      /*print("Slider Length ${slider.length}");*/
      emit(loadedState(slider));
    }catch(e){
      emit(errorState("Error in api $e"));
    }
  }
}