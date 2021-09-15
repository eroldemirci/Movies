import 'package:movies/models/movies_searchResponse.dart';

abstract class MoviesSearchState {
  const MoviesSearchState();
}

class MoviesSearchInitialState extends MoviesSearchState {
  const MoviesSearchInitialState();
}

class MoviesSearchLoadingState extends MoviesSearchState {
  const MoviesSearchLoadingState();
}

class MoviesSearchLoadedState extends MoviesSearchState {
  const MoviesSearchLoadedState(
    this.searchResponse,
  );
  final SearchResponse? searchResponse;
}

class MoviesSearchErrorState extends MoviesSearchState {
  const MoviesSearchErrorState(this.message);
  final String message;
}
