import 'package:equatable/equatable.dart';
import '../model/LatestChannelModel.dart';
abstract class LatestChannelState extends Equatable{}
class LatestChannelInitialState extends LatestChannelState {
  @override
  List<Object> get props => [];
}
class LatestChannelLoadingState extends LatestChannelState {
  @override
  List<LatestChannelModel> get props => [];
}
class LatestChannelLoadedState extends LatestChannelState {


  final List<LatestChannelModel> slider;
  LatestChannelLoadedState(this.slider);

  @override
  List<LatestChannelModel> get props => slider;
}
class LatestChannelErrorState extends LatestChannelState {
  final String error;
  LatestChannelErrorState(this.error);
  @override
  List<Object> get props => [error];
}

