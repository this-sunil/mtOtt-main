import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/model/BannerModel.dart';
import '../../Service/state/MovieSliderState.dart';
import '../Repository/MovieSliderRepository.dart';
/*Upcoming Banner with Movie Screen Bloc State Management*/
class UpComingMovieSliderCubit extends Cubit<MovieSliderState>{
  UpComingMovieSliderCubit() : super(InitialState()) {
    fetchSlider();
  }
  MovieSliderRepository movieSliderRepository=MovieSliderRepository();
  fetchSlider() async{
    debugPrint("Upcoming Banner with Movie Screen Bloc State Management");
    try{
      final List<BannerModel> slider=await movieSliderRepository.fetchMovieSlider();
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedState(slider));
    }catch(e){
      emit(ErrorState("Error in api $e"));
    }
  }
}