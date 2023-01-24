import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.dark());

  void toggleTheme(){
    if(state==ThemeData.light(useMaterial3: true).copyWith(primaryColorLight: Colors.white)){
      emit(ThemeData.dark(useMaterial3: true));
    }
    else{
      emit(ThemeData.light(useMaterial3: true).copyWith(primaryColorLight: Colors.white));
    }
  }
}