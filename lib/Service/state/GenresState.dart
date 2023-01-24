import 'package:equatable/equatable.dart';
import '../model/GenresModel.dart';
abstract class GenresState extends Equatable{}
class GenresInitialState extends GenresState {
  @override
  List<Object> get props => [];
}
class GenresLoadingState extends GenresState {
  @override
  List<GenresModel> get props => [];
}
class GenresLoadedState extends GenresState {


  final List<GenresModel> slider;
  GenresLoadedState(this.slider);

  @override
  List<GenresModel> get props => slider;
}
class GenresErrorState extends GenresState {
  final String error;
  GenresErrorState(this.error);
  @override
  List<Object> get props => [error];
}

