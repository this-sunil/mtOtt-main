import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/MoreLikeModel.dart';
abstract class MoreLikeState extends Equatable{}
class InitialState extends MoreLikeState {
  @override
  List<Object> get props => [];
}
class LoadingState extends MoreLikeState {
  @override
  List<MoreLikeModel> get props => [];
}
class LoadedState extends MoreLikeState {


  final List<MoreLikeModel> slider;
  LoadedState(this.slider);

  @override
  List<MoreLikeModel> get props => slider;
}
class ErrorState extends MoreLikeState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

