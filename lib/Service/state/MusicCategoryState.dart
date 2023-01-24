import 'package:equatable/equatable.dart';
import '../model/MusicCategoryModel.dart';
abstract class MusicCategoryState extends Equatable{}
class MusicCategoryInitialState extends MusicCategoryState {
  @override
  List<Object> get props => [];
}
class MusicCategoryLoadingState extends MusicCategoryState {
  @override
  List<MusicCategoryModel> get props => [];
}
class MusicCategoryLoadedState extends MusicCategoryState {


  final List<MusicCategoryModel> slider;
  MusicCategoryLoadedState(this.slider);

  @override
  List<MusicCategoryModel> get props => slider;
}
class MusicCategoryErrorState extends MusicCategoryState {
  final String error;
  MusicCategoryErrorState(this.error);
  @override
  List<Object> get props => [error];
}

