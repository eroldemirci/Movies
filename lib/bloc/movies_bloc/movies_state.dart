import 'package:movies/models/movies_popular.dart';

abstract class MoviesPopularState {
  const MoviesPopularState();
}

class MoviesPopularInitialState extends MoviesPopularState {
  const MoviesPopularInitialState();
}

class MoviesPopularLoadingState extends MoviesPopularState {
  const MoviesPopularLoadingState();
}

class MoviesPopularLoadedState extends MoviesPopularState {
  const MoviesPopularLoadedState(
    this.popularMoviesPopular,
  );
  final MoviesPopular? popularMoviesPopular;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoviesPopularLoadedState &&
        o.popularMoviesPopular == popularMoviesPopular;
  }

  @override
  int get hashCode => popularMoviesPopular.hashCode;
}

class MoviesPopularErrorState extends MoviesPopularState {
  const MoviesPopularErrorState(this.message);
  final String message;
}
