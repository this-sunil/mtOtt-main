import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/WebSeriesRepository.dart';
import 'package:mtott/Service/state/RuningWebSeriesState.dart';
import '../model/RuningWebSeriesModel.dart';
/*Upcoming Banner with WebSeries Screen Bloc State Management*/
class RunningWebSeriesCubit extends Cubit<RunningWebSeriesState>{
  RunningWebSeriesCubit() : super(InitialStates()) {
    fetchSlider();
  }
  WebSeriesRepository webSeriesRepository=WebSeriesRepository();
  fetchSlider() async{
    debugPrint("Upcoming Banner with WebSeries Screen Bloc State Management");
    try{
      final List<RunningWebSeriesModel> slider=await webSeriesRepository.fetchRunningBanner();
      /*print("Slider Length ${slider.length}");*/
      emit(LoadedStates(slider));
    }catch(e){
      emit(ErrorStates("Error in api $e"));
    }
  }
}