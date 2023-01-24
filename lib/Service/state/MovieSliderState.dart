import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/BannerModel.dart';
abstract class MovieSliderState extends Equatable{}
class InitialState extends MovieSliderState {
  @override
  List<Object> get props => [];
}
class LoadingState extends MovieSliderState {
  @override
  List<BannerModel> get props => [];
}
class LoadedState extends MovieSliderState {


  final List<BannerModel> slider;
  LoadedState(this.slider);

  @override
  List<BannerModel> get props => slider;
}
class ErrorState extends MovieSliderState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

