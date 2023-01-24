import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/SeriesRepository.dart';
import 'package:mtott/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/SeriesModel.dart';
import '../state/SeriesState.dart';
/* Season Bloc State Management*/
class SeriesCubit extends Cubit<SeriesState>{
  SeriesCubit() : super(SeriesInitialState());
  SeriesRepository seriesRepository=SeriesRepository();
  fetchTVSeries(String seriesId) async{
    debugPrint("TV Series");
    SharedPreferences pref=await SharedPreferences.getInstance();
    try{
      final List<SeriesModel> slider=await seriesRepository.fetchSeries(seriesId);
      debugPrint("TV Series Response $slider");

      pref.setString("series", slider[0].data[0].id);
      
      emit(SeriesLoadedState(slider));
    }catch(e){
      emit(SeriesErrorState("Error in api $e"));
    }
  }
}