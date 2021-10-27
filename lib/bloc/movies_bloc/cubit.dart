import 'package:flutter_bloc/flutter_bloc.dart';
import 'movies_state.dart';
import '../../models/movies_popular.dart';
import '../../repository/movies_repository.dart';

class MoviesCubit extends Cubit<MoviesPopularState> {
  MoviesCubit(this._repository) : super(MoviesPopularInitialState());

  final MovieRepository _repository;
  int pageNum = 1;

  Future getMoviePopular(int pageNum) async {
    try {
      emit(MoviesPopularLoadingState());
      final MoviesPopular? response =
          await _repository.getPopularMovies(pageNum);

      emit(MoviesPopularLoadedState(response));
    } catch (e) {
      emit(MoviesPopularErrorState('Hata oluştu : $e'));
    }
  }
}
