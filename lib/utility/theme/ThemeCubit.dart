import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.dark().copyWith(
      cardColor: const Color(0xFF222222),
      appBarTheme:   AppBarTheme(
          titleTextStyle:GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 20,color:
          Colors.white),
          backgroundColor: const Color(0xFF222222))));

  void toggleTheme(){
    if(state==ThemeData.light().copyWith(primaryColorLight: Colors.white,
        cardColor: Colors.white,
        appBarTheme:  AppBarTheme(
            titleTextStyle:GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 20,color:
            Colors.black),

            backgroundColor: Colors.white))){
      emit(ThemeData.dark().copyWith(
          cardColor: const Color(0xFF222222),
          appBarTheme:   AppBarTheme(
              titleTextStyle:GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 20,color:
              Colors.white),
              backgroundColor: const Color(0xFF222222))));
    }
    else{
      emit(ThemeData.light().copyWith(primaryColorLight: Colors.white,
          cardColor: Colors.white,
          appBarTheme:  AppBarTheme(
            titleTextStyle:GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 20,color:
            Colors.black),

          backgroundColor: Colors.white)));
    }
  }
}