import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/WatchListRepository.dart';
import '../model/WatchListModel.dart';
import '../state/WatchListState.dart';
/*Latest Movies Api with Bloc State Management*/
class WatchListCubit extends Cubit<WatchListState>{
  WatchListCubit() : super(InitialState());
  WatchListRepository watchListRepository=WatchListRepository();
  fetchWatchList(String userId) async{
    debugPrint("Music Category Screen Bloc State Management");
    /*try{*/
      final List<WatchListModel> slider=await watchListRepository.fetchWatchList(userId);
      print("Slider Length ${slider.length}");
      emit(LoadedState(slider));
   /* }catch(e){
      emit(ErrorState("Error in api $e"));
    }*/
  }
}