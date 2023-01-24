import 'package:equatable/equatable.dart';
import '../model/WatchListModel.dart';
abstract class WatchListState extends Equatable{}
class InitialState extends WatchListState {
  @override
  List<Object> get props => [];
}
class LoadingState extends WatchListState {
  @override
  List<WatchListModel> get props => [];
}
class LoadedState extends WatchListState {
  final List<WatchListModel> slider;
  LoadedState(this.slider);
  @override
  List<WatchListModel> get props => slider;
}
class ErrorState extends WatchListState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

