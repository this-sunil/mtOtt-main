import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtott/Service/model/SearchModel.dart';
import 'package:mtott/Service/state/SearchState.dart';
import '../Repository/SearchRepository.dart';


class SearchCubit extends Cubit<SearchState>{
  SearchCubit():super(InitialStates());
  SearchRepository searchRepository=SearchRepository();
  searchMovies(String title) async{
    debugPrint("Search Screen Bloc State Management");
    try{
      final List<SearchModel> slider=await searchRepository.searchMovie(title);
      print("Slider Search Length ${slider.length}");
      if(slider.first.status==true){
        emit(LoadedStates(slider));
      }
      else{
        emit(LoadingStates());
      }

    }catch(e){
      emit(ErrorStates("Error in api $e"));
    }
  }

}