import 'package:equatable/equatable.dart';
import '../model/RuningSongModel.dart';
abstract class RuningSongState extends Equatable{}
class InitialStates extends RuningSongState {
  @override
  List<Object> get props => [];
}
class LoadingStates extends RuningSongState {
  @override
  List<RuningSongModel> get props => [];
}
class LoadedStates extends RuningSongState {


  final List<RuningSongModel> slider;
  LoadedStates(this.slider);

  @override
  List<RuningSongModel> get props => slider;
}
class ErrorStates extends RuningSongState {
  final String error;
  ErrorStates(this.error);
  @override
  List<Object> get props => [error];
}

