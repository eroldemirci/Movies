import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movies_cast.dart';
import '../models/movies_detail.dart';
import '../models/movies_images.dart';

import '../models/movies_playing_now.dart';
import '../models/movies_popular.dart';
import '../models/movies_searchResponse.dart';
import '../models/movies_similiar.dart';
import '../models/movies_videos.dart';
import '../utils/servide_urls.dart';

class MoviesService {
  static const API_KEY = 'b73079f95004009e631f7d132933d45e';
  http.Client client = http.Client();
  
  
  Future<MoviesPopular?>? getMoviePopular(int pageNum) async {
    var response = await client.get(Uri.parse(MOVIES_BASEURL +
        'popular?api_key=' +
        API_KEY +
        '&language=tr-TR' +
        '&page=$pageNum'));
    print('Popular Service');
    switch (response.statusCode) {
      case 200:
        MoviesPopular? result =
            MoviesPopular.fromJson(jsonDecode(response.body));
        return result;

      default:
        return null;
    }
  }

  Future<MoviesNowPlaying?>? getMoviePlayingNow(int pageNum) async {
    var response = await client.get(Uri.parse(MOVIES_BASEURL +
        'now_playing?api_key=' +
        API_KEY +
        '&language=tr-TR' +
        '&page=$pageNum'));

    print('Playing now Service');
    switch (response.statusCode) {
      case 200:
        MoviesNowPlaying? result =
            MoviesNowPlaying.fromJson(jsonDecode(response.body));
        return result;

      default:
        return null;
    }
  }

  Future<MoviesDetail?> getMovieDetail(int id) async {
    var response = await client.get(Uri.parse(
        MOVIES_BASEURL + '$id' + '?api_key=' + API_KEY + '&language=tr-TR'));

    switch (response.statusCode) {
      case 200:
        MoviesDetail? result = MoviesDetail.fromJson(jsonDecode(response.body));
        return result;
      default:
        return null;
    }
  }

  Future<MoviesImages?> getMovieImages(int id) async {
    var response = await client.get(
        Uri.parse(MOVIES_BASEURL + '$id' + '/images' + '?api_key=' + API_KEY));
    switch (response.statusCode) {
      case 200:
        MoviesImages result = MoviesImages.fromJson(jsonDecode(response.body));
        return result;
      default:
        return null;
    }
  }

  Future<MoviesSimiliar?> getMoviesSimiliar(int id) async {
    var response = await client.get(
        Uri.parse(MOVIES_BASEURL + '$id' + '/similar' + '?api_key=' + API_KEY));
    switch (response.statusCode) {
      case 200:
        MoviesSimiliar? result =
            MoviesSimiliar.fromJson(jsonDecode(response.body));
        return result;
      default:
        return null;
    }
  }

  Future<MoviesCasts?> getMovieCast(int id) async {
    var response = await client.get(
        Uri.parse(MOVIES_BASEURL + '$id' + '/credits' + '?api_key=' + API_KEY));
    switch (response.statusCode) {
      case 200:
        MoviesCasts? result = MoviesCasts.fromJson(jsonDecode(response.body));
        return result;
      default:
        return null;
    }
  }

  Future<MoviesVideos?> getMovieVideos(int id, String language) async {
    var response = await client.get(Uri.parse(MOVIES_BASEURL +
        '$id' +
        '/videos' +
        '?api_key=' +
        API_KEY +
        '&language=$language'));
    switch (response.statusCode) {
      case 200:
        MoviesVideos? result = MoviesVideos.fromJson(jsonDecode(response.body));
        return result;
      default:
        return null;
    }
  }

  Future<SearchResponse?> searchMovie(String query, String language) async {
    var response = await client.get(Uri.parse(SEARCH_BASEURL +
        'movie?api_key=' +
        API_KEY +
        '&language=$language' +
        '&query=$query'));
    switch (response.statusCode) {
      case 200:
        SearchResponse result =
            SearchResponse.fromJson(jsonDecode(response.body));
        return result;
      default:
        return null;
    }
  }
}
