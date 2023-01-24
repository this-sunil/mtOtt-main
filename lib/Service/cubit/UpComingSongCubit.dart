import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/SongsRepository.dart';
import 'package:mtott/Service/model/UpComingSongsModel.dart';
import '../state/UpComingSongState.dart';


/*Upcoming Banner with Song Screen Bloc State Management*/
class UpComingSongsCubit extends Cubit<UpComingSongState>{
  UpComingSongsCubit() : super(InitialState()) {
    fetchSlider();
  }
  SongsRepository sliderRepository=SongsRepository();
  fetchSlider() async{
    debugPrint("Upcoming Banner with Song Screen Bloc State Management");
    try{
      final List<UpComingSongModel> slider=await sliderRepository.fetchUpcomingBanner();
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedState(slider));
    }catch(e){
      emit(ErrorState("Error in api $e"));
    }
  }
}