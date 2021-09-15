import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_search_bloc/movies_search_state.dart';
import 'package:movies/repository/movies_repository.dart';

class MoviesSearchCubit extends Cubit<MoviesSearchState> {
  MoviesSearchCubit(this._repository) : super(MoviesSearchInitialState());
  final MovieRepository _repository;
  String? language = 'tr-TR';
  bool isValueEmpty = true;

  setValueState(bool state) {
    isValueEmpty = state;
  }

  Future searchMovie(String query, String language) async {
    try {
      if (query == '') {
        emit(MoviesSearchInitialState());
      } else {
        emit(MoviesSearchLoadingState());
        final response = await _repository.getSearch(query, language);
        emit(MoviesSearchLoadedState(response));
      }
    } catch (e) {
      emit(MoviesSearchErrorState('Hata oluştu : ' + e.toString()));
    }
  }
}
