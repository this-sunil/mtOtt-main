import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mtott/Service/model/BannerModel.dart';
import 'package:mtott/Service/model/RuningHomeModel.dart';
abstract class RuningHomeState extends Equatable{}
class InitialState extends RuningHomeState {
  @override
  List<Object> get props => [];
}
class LoadingStates extends RuningHomeState {
  @override
  List<RuningHomeModel> get props => [];
}
class LoadedStates extends RuningHomeState {
  final List<RuningHomeModel> slider;
  LoadedStates(this.slider);
  @override
  List<RuningHomeModel> get props => slider;
}
class ErrorStates extends RuningHomeState {
  final String error;
  ErrorStates(this.error);
  @override
  List<Object> get props => [error];
}

