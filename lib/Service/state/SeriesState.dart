import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/SeriesModel.dart';

abstract class SeriesState extends Equatable{}
class SeriesInitialState extends SeriesState {
  @override
  List<Object> get props => [];
}
class SeriesLoadingState extends SeriesState {
  @override
  List<SeriesModel> get props => [];
}
class SeriesLoadedState extends SeriesState {


  final List<SeriesModel> slider;
  SeriesLoadedState(this.slider);

  @override
  List<SeriesModel> get props => slider;
}
class SeriesErrorState extends SeriesState {
  final String error;
  SeriesErrorState(this.error);
  @override
  List<Object> get props => [error];
}

