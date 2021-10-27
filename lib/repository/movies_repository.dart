import 'package:firebase_auth/firebase_auth.dart';

import '../models/movies_cast.dart';
import '../models/movies_detail.dart';
import '../models/movies_images.dart';
import '../models/movies_playing_now.dart';
import '../models/movies_popular.dart';
import '../models/movies_searchResponse.dart';
import '../models/movies_videos.dart';
import '../services/auth_service.dart';
import '../services/movies_services.dart';

class MovieRepository {
  MoviesService _service = MoviesService();
  AuthService _authService = AuthService();

  Future<UserCredential?> createUserWithEmail(String email, String password)async{
    UserCredential? response = await _authService.createUser(email, password);
    return response;
  }

  Future<MoviesPopular?> getPopularMovies(int pageNum) async {
    MoviesPopular? response = await _service.getMoviePopular(pageNum);
    print("Popular Repository " + response.toString());
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<MoviesNowPlaying?> getPlayingNowMovies(int pageNum) async {
    MoviesNowPlaying? response = await _service.getMoviePlayingNow(pageNum);
    print("Playing Now Repository " + response.toString());
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<MoviesDetail?> getMovieDetail(int id) async {
    var response = await _service.getMovieDetail(id);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<MoviesImages?> getMovieImages(int id) async {
    var response = await _service.getMovieImages(id);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future getMoviesSimiliar(int id) async {
    var response = await _service.getMoviesSimiliar(id);
    return response;
  }

  Future<MoviesCasts?> getMoviesCast(int id) async {
    var response = await _service.getMovieCast(id);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<MoviesVideos?> getMovieVideos(int id, String language) async {
    var response = await _service.getMovieVideos(id, language);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  Future<SearchResponse?> getSearch(String query, String language) async {
    SearchResponse? response = await _service.searchMovie(query, language);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }
}
