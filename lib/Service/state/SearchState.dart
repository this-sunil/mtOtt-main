import 'package:equatable/equatable.dart';
import '../model/SearchModel.dart';
abstract class SearchState extends Equatable{}
class InitialStates extends SearchState {
  @override
  List<Object> get props => [];
}
class LoadingStates extends SearchState {
  @override
  List<SearchModel> get props => [];
}
class LoadedStates extends SearchState {
  final List<SearchModel> slider;
  LoadedStates(this.slider);
  @override
  List<SearchModel> get props => slider;
}
class ErrorStates extends SearchState {
  final String error;
  ErrorStates(this.error);
  @override
  List<Object> get props => [error];
}

