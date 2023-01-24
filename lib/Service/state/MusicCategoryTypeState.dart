import 'package:equatable/equatable.dart';
import '../model/MusicCategoryTypeModel.dart';
abstract class MusicCategoryTypeState extends Equatable{}
class MusicCategoryTypeInitialState extends MusicCategoryTypeState {
  @override
  List<Object> get props => [];
}
class MusicCategoryTypeLoadingState extends MusicCategoryTypeState {
  @override
  List<MusicCategoryTypeModel> get props => [];
}
class MusicCategoryTypeLoadedState extends MusicCategoryTypeState {

  final List<MusicCategoryTypeModel> slider;
  MusicCategoryTypeLoadedState(this.slider);

  @override
  List<MusicCategoryTypeModel> get props => slider;
}
class MusicCategoryTypeErrorState extends MusicCategoryTypeState {
  final String error;
  MusicCategoryTypeErrorState(this.error);
  @override
  List<Object> get props => [error];
}

