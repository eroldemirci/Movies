import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies/bloc/movies_videos_bloc/movies_videos_state.dart';

import 'package:movies/models/movies_videos.dart';
import 'package:movies/repository/movies_repository.dart';

class MoviesVideosCubit extends Cubit<MoviesVideosState> {
  MoviesVideosCubit(this._repository) : super(MoviesVideosInitialState());
  final MovieRepository _repository;

  getMovieVideos(int id, String language) async {
    language = 'tr-TR';
    try {
      emit(MoviesVideosLoadingState());

      final MoviesVideos? responseVideos =
          await _repository.getMovieVideos(id, language);
      emit(MoviesVideosLoadedState(responseVideos));
    } catch (e) {
      emit(MoviesVideosErrorState('Beklenmedik bir Hata Oluştu : $e'));
    }
  }
}
