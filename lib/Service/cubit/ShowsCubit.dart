import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/Repository/ShowsRepository.dart';
import 'package:mtott/Service/model/ShowsModel.dart';
import '../state/ShowsState.dart';
/*TV Shows with Home Screen Bloc State Management*/
class ShowsCubit extends Cubit<ShowsState>{
  ShowsCubit() : super(ShowsInitialState()) {
    fetchTVShows();
  }
  ShowsRepository showsRepository=ShowsRepository();
  fetchTVShows() async{
    debugPrint("TV Shows");
    try{
      final List<ShowsModel> slider=await showsRepository.fetchShows();

      emit(ShowsLoadedState(slider));
    }catch(e){
      emit(ShowsErrorState("Error in api $e"));
    }
  }
}