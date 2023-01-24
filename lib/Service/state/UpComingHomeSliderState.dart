import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/BannerModel.dart';
abstract class UpComingHomeSliderState extends Equatable{}
class InitialState extends UpComingHomeSliderState {
  @override
  List<Object> get props => [];
}
class LoadingState extends UpComingHomeSliderState {
  @override
  List<BannerModel> get props => [];
}
class LoadedState extends UpComingHomeSliderState {


  final List<BannerModel> slider;
  LoadedState(this.slider);

  @override
  List<BannerModel> get props => slider;
}
class ErrorState extends UpComingHomeSliderState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

