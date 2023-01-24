import 'package:equatable/equatable.dart';
import '../model/UpComingSongsModel.dart';
abstract class UpComingSongState extends Equatable{}
class InitialState extends UpComingSongState {
  @override
  List<Object> get props => [];
}
class LoadingState extends UpComingSongState {
  @override
  List<UpComingSongModel> get props => [];
}
class LoadedState extends UpComingSongState {
  final List<UpComingSongModel> slider;
  LoadedState(this.slider);
  @override
  List<UpComingSongModel> get props => slider;
}
class ErrorState extends UpComingSongState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

