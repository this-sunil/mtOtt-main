import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.dark().copyWith(
      cardColor: const Color(0xFF222222),
      appBarTheme: const AppBarTheme(

      backgroundColor: Color(0xFF222222))));

  void toggleTheme(){
    if(state==ThemeData.light().copyWith(primaryColorLight: Colors.white,appBarTheme: const AppBarTheme(
       backgroundColor: Colors.white))){
      emit(ThemeData.dark().copyWith(
          cardColor: const Color(0xFF222222),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF222222))));
    }
    else{
      emit(ThemeData.light().copyWith(primaryColorLight: Colors.white,
          cardColor: Colors.white,
          appBarTheme: const AppBarTheme(

          backgroundColor: Colors.white)));
    }
  }
}