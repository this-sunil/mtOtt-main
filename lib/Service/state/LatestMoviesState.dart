import 'package:equatable/equatable.dart';
import '../model/LatestMoviesModel.dart';
abstract class LatestMovieState extends Equatable{}
class LatestMovieInitialState extends LatestMovieState {
  @override
  List<Object> get props => [];
}
class LatestMovieLoadingState extends LatestMovieState {
  @override
  List<LatestMoviesModel> get props => [];
}
class LatestMovieLoadedState extends LatestMovieState {


  final List<LatestMoviesModel> slider;
  LatestMovieLoadedState(this.slider);

  @override
  List<LatestMoviesModel> get props => slider;
}
class LatestMovieErrorState extends LatestMovieState {
  final String error;
  LatestMovieErrorState(this.error);
  @override
  List<Object> get props => [error];
}

