import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/TopPicksModel.dart';

abstract class TopPicksState extends Equatable{}
class TopPicksInitialState extends TopPicksState {
  @override
  List<Object> get props => [];
}
class TopPicksLoadingState extends TopPicksState {
  @override
  List<TopPicksModel> get props => [];
}
class TopPicksLoadedState extends TopPicksState {


  final List<TopPicksModel> slider;
  TopPicksLoadedState(this.slider);

  @override
  List<TopPicksModel> get props => slider;
}
class TopPicksErrorState extends TopPicksState {
  final String error;
  TopPicksErrorState(this.error);
  @override
  List<Object> get props => [error];
}

