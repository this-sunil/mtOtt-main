import 'package:equatable/equatable.dart';
import 'package:mtott/Service/model/WebSeriesModel.dart';
abstract class UpComingSeriesState extends Equatable{}
class initialState extends UpComingSeriesState {
  @override
  List<Object> get props => [];
}
class loadingState extends UpComingSeriesState {
  @override
  List<WebSeriesModel> get props => [];
}
class loadedState extends UpComingSeriesState {

  final List<WebSeriesModel> slider;
  loadedState(this.slider);

  @override
  List<WebSeriesModel> get props => slider;
}
class errorState extends UpComingSeriesState {
  final String error;
  errorState(this.error);
  @override
  List<Object> get props => [error];
}

