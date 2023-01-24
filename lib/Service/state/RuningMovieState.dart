import 'package:equatable/equatable.dart';


import '../model/RuningMovieModel.dart';
abstract class RuningMovieState extends Equatable{}
class InitialStates extends RuningMovieState {
  @override
  List<Object> get props => [];
}
class LoadingStates extends RuningMovieState {
  @override
  List<RuningMovieModel> get props => [];
}
class LoadedStates extends RuningMovieState {


  final List<RuningMovieModel> slider;
  LoadedStates(this.slider);

  @override
  List<RuningMovieModel> get props => slider;
}
class ErrorStates extends RuningMovieState {
  final String error;
  ErrorStates(this.error);
  @override
  List<Object> get props => [error];
}

