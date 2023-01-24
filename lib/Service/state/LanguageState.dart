import 'package:equatable/equatable.dart';
import '../model/LanguageModel.dart';
abstract class LanguageState extends Equatable{}
class LanguageInitialState extends LanguageState {
  @override
  List<Object> get props => [];
}
class LanguageLoadingState extends LanguageState {
  @override
  List<LanguageModel> get props => [];
}
class LanguageLoadedState extends LanguageState {


  final List<LanguageModel> slider;
  LanguageLoadedState(this.slider);

  @override
  List<LanguageModel> get props => slider;
}
class LanguageErrorState extends LanguageState {
  final String error;
  LanguageErrorState(this.error);
  @override
  List<Object> get props => [error];
}

