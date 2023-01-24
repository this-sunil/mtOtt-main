import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/SeasonRepository.dart';
import 'package:mtott/Service/model/SeasonModel.dart';
import '../state/SeasonState.dart';
/* Season Bloc State Management*/
class SeasonCubit extends Cubit<SeasonState>{
  SeasonCubit() : super(SeasonInitialState());
  SeasonRepository seasonRepository=SeasonRepository();
  fetchTVSeason(String seriesId,String seasonId) async{
    debugPrint("TV Season");
    try{
      final List<SeasonModel> slider=await seasonRepository.fetchSeason(seriesId, seasonId);
      debugPrint("TV Season Response ${slider.first.data.map((e) => e.episodeTitle).toList()}");

      emit(SeasonLoadedState(slider));
    }catch(e){
      emit(SeasonErrorState("Error in api $e"));
    }
  }
}