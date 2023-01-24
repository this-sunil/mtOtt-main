import 'package:equatable/equatable.dart';
import '../model/RuningWebSeriesModel.dart';
abstract class RunningWebSeriesState extends Equatable{}
class InitialStates extends RunningWebSeriesState {
  @override
  List<Object> get props => [];
}
class LoadingStates extends RunningWebSeriesState {
  @override
  List<RunningWebSeriesModel> get props => [];
}
class LoadedStates extends RunningWebSeriesState {


  final List<RunningWebSeriesModel> slider;
  LoadedStates(this.slider);

  @override
  List<RunningWebSeriesModel> get props => slider;
}
class ErrorStates extends RunningWebSeriesState {
  final String error;
  ErrorStates(this.error);
  @override
  List<Object> get props => [error];
}

