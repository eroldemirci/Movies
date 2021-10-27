import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_detail_state.dart';
import '../../models/movies_cast.dart';
import '../../models/movies_detail.dart';
import '../../models/movies_images.dart';
import '../../models/movies_similiar.dart';
import '../../models/movies_videos.dart';
import '../../repository/movies_repository.dart';

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
      // final MoviesVideos? responseVideos =
      //     await _repository.getMovieVideos(id, language);
      emit(MoviesDetailLoadedState(response, responseImages, responseSimiliar,
          responseCasts,));
    } catch (e) {
      emit(MoviesDetailErrorState('Beklenmedik bir Hata Oluştu \n\n $e'));
    }
  }
}
