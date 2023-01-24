import 'package:equatable/equatable.dart';
import '../model/GenresCategoryModel.dart';
abstract class GenresCategoryState extends Equatable{}
class InitialState extends GenresCategoryState {
  @override
  List<Object> get props => [];
}
class LoadingState extends GenresCategoryState {
  @override
  List<GenresCategoryModel> get props => [];
}
class LoadedState extends GenresCategoryState {


  final List<GenresCategoryModel> slider;
  LoadedState(this.slider);

  @override
  List<GenresCategoryModel> get props => slider;
}
class ErrorState extends GenresCategoryState {
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props => [error];
}

