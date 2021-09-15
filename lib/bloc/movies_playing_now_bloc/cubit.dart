import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_playing_now_bloc/state.dart';
import 'package:movies/models/movies_playing_now.dart';
import 'package:movies/repository/movies_repository.dart';

class MoviesPlayingNowCubit extends Cubit<MoviesPlayingNowState> {
  MoviesPlayingNowCubit(this._repository)
      : super(MoviesPlayingNowInitialState());
  final MovieRepository _repository;
  int pageNum = 1;

  getMoviePlayingNow(int pageNum) async {
    try {
      emit(MoviesPlayingNowLoadingState());
      print('Cubit Çağırılıyor');
      MoviesNowPlaying? response =
          await _repository.getPlayingNowMovies(pageNum);
      print('Cubit  Çağırıldı ' + response!.results![2]!.title!.toString());
      emit(MoviesPlayingNowLoadedState(response));
    } on Exception {
      emit(MoviesPlayingNowErrorState('Hata Oluştu'));
    }
  }
}
