import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/TopPicksRepository.dart';
import 'package:mtott/Service/model/TopPicksModel.dart';
import 'package:mtott/Service/state/TopPicksState.dart';
/*TV Shows with Home Screen Bloc State Management*/
class TopPicksCubit extends Cubit<TopPicksState>{
  TopPicksCubit() : super(TopPicksInitialState()) {
    fetchTopPicks();
  }
  TopPicksRepository topPicksRepository=TopPicksRepository();
  fetchTopPicks() async{
    debugPrint("TV Shows");
    try{
      final List<TopPicksModel> slider=await topPicksRepository.fetchTopPick();
      debugPrint("Top Picks Data $slider");
      emit(TopPicksLoadedState(slider));
    }catch(e){
      emit(TopPicksErrorState("Error in api $e"));
    }
  }
}