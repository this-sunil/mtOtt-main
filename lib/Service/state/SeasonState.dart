import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/SeasonModel.dart';

abstract class SeasonState extends Equatable{}
class SeasonInitialState extends SeasonState {
  @override
  List<Object> get props => [];
}
class SeasonLoadingState extends SeasonState {
  @override
  List<SeasonModel> get props => [];
}
class SeasonLoadedState extends SeasonState {


  final List<SeasonModel> slider;
  SeasonLoadedState(this.slider);

  @override
  List<SeasonModel> get props => slider;
}
class SeasonErrorState extends SeasonState {
  final String error;
  SeasonErrorState(this.error);
  @override
  List<Object> get props => [error];
}

