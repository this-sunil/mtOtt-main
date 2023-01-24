import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/ShowsModel.dart';

abstract class ShowsState extends Equatable{}
class ShowsInitialState extends ShowsState {
  @override
  List<Object> get props => [];
}
class ShowsLoadingState extends ShowsState {
  @override
  List<ShowsModel> get props => [];
}
class ShowsLoadedState extends ShowsState {


  final List<ShowsModel> slider;
  ShowsLoadedState(this.slider);

  @override
  List<ShowsModel> get props => slider;
}
class ShowsErrorState extends ShowsState {
  final String error;
  ShowsErrorState(this.error);
  @override
  List<Object> get props => [error];
}

