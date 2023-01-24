import 'package:equatable/equatable.dart';
import '../model/PopularModel.dart';
abstract class PopularState extends Equatable{}
class InitialPopularState extends PopularState {
  @override
  List<Object> get props => [];
}
class LoadingPopularState extends PopularState {
  @override
  List<PopularModel> get props => [];
}
class LoadedPopularState extends PopularState {


  final List<PopularModel> slider;
  LoadedPopularState(this.slider);

  @override
  List<PopularModel> get props => slider;
}
class ErrorPopularState extends PopularState {
  final String error;
  ErrorPopularState(this.error);
  @override
  List<Object> get props => [error];
}

