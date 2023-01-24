import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';



class InternetCubit extends Cubit<InternetState>{
  Connectivity connectivity=Connectivity();
  StreamSubscription? _streamSubScription;
  InternetCubit() : super(InternetState.internetInitial) {
   fetchInternetConnection();
  }
  fetchInternetConnection(){
    debugPrint("Started Internet");
    _streamSubScription=connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        emit(InternetState.internetSuccess);
      }
      else {
        emit(InternetState.internetFailure);
      }
    });
  }
  @override
  Future<void> close() {
    _streamSubScription?.cancel();
    return super.close();
  }
}