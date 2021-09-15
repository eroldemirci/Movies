import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_detail_bloc/movie_detail_state.dart';
import 'package:movies/models/movies_cast.dart';
import 'package:movies/models/movies_detail.dart';
import 'package:movies/models/movies_images.dart';
import 'package:movies/models/movies_similiar.dart';
import 'package:movies/models/movies_videos.dart';
import 'package:movies/repository/movies_repository.dart';

class MoviesDetailCubit extends Cubit<MoviesDetailState> {
  MoviesDetailCubit(this._repository) : super(MoviesDetailInitialState());
  final MovieRepository _repository;
  int? movieID;
  String? language = 'tr-TR';
  String? videoId = '';

  setMovieId(int id) {
    movieID = id;
  }

  getMovieDetail(int id, String language) async {
    try {
      emit(MoviesDetailLoadingState());
      final MoviesDetail? response = await _repository.getMovieDetail(id);
      final MoviesImages? responseImages = await _repository.getMovieImages(id);
      final MoviesSimiliar? responseSimiliar =
          await _repository.getMoviesSimiliar(id);
      final MoviesCasts? responseCasts = await _repository.getMoviesCast(id);
      final MoviesVideos? responseVideos =
          await _repository.getMovieVideos(id, language);
      emit(MoviesDetailLoadedState(response, responseImages, responseSimiliar,
          responseCasts, responseVideos));
    } catch (e) {
      emit(MoviesDetailErrorState('Beklenmedik bir Hata Oluştu : $e'));
    }
  }
}
