import 'package:movies/models/movies_videos.dart';

abstract class MoviesVideosState {
  const MoviesVideosState();
}

class MoviesVideosInitialState extends MoviesVideosState {
  const MoviesVideosInitialState();
}

class MoviesVideosLoadingState extends MoviesVideosState {
  const MoviesVideosLoadingState();
}

class MoviesVideosLoadedState extends MoviesVideosState {
  const MoviesVideosLoadedState(
    this.moviesVideos,
  );
  final MoviesVideos? moviesVideos;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoviesVideosLoadedState && o.moviesVideos == moviesVideos;
  }

  @override
  int get hashCode => moviesVideos.hashCode;
}

class MoviesVideosErrorState extends MoviesVideosState {
  const MoviesVideosErrorState(this.message);
  final String message;
}
