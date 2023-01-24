import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/model/RuningMovieModel.dart';
import 'package:mtott/Service/state/RuningMovieState.dart';
import '../Repository/MovieSliderRepository.dart';
/*Upcoming Banner with Movie Screen Bloc State Management*/
class RuningMovieSliderCubit extends Cubit<RuningMovieState>{
  RuningMovieSliderCubit() : super(InitialStates()) {
    fetchSlider();
  }
  MovieSliderRepository sliderRepository=MovieSliderRepository();
  fetchSlider() async{
    debugPrint("Upcoming Banner with Movie Screen Bloc State Management");
    try{
      final List<RuningMovieModel> slider=await sliderRepository.fetchMovieBanner();
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedStates(slider));
    }catch(e){
      emit(ErrorStates("Error in api $e"));
    }
  }
}