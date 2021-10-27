import '../../models/movies_playing_now.dart';

abstract class MoviesPlayingNowState {
  const MoviesPlayingNowState();
}

class MoviesPlayingNowInitialState extends MoviesPlayingNowState {
  const MoviesPlayingNowInitialState();
}

class MoviesPlayingNowLoadingState extends MoviesPlayingNowState {
  const MoviesPlayingNowLoadingState();
}

class MoviesPlayingNowLoadedState extends MoviesPlayingNowState {
  const MoviesPlayingNowLoadedState(
    this.playingNowMovies,
  );
  final MoviesNowPlaying? playingNowMovies;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoviesPlayingNowLoadedState &&
        o.playingNowMovies == playingNowMovies;
  }

  @override
  int get hashCode => playingNowMovies.hashCode;
}

class MoviesPlayingNowErrorState extends MoviesPlayingNowState {
  const MoviesPlayingNowErrorState(this.message);
  final String message;
}
