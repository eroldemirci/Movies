import '../../models/movies_cast.dart';
import '../../models/movies_detail.dart';
import '../../models/movies_images.dart';
import '../../models/movies_similiar.dart';
import '../../models/movies_videos.dart';

abstract class MoviesDetailState {
  const MoviesDetailState();
}

class MoviesDetailInitialState extends MoviesDetailState {
  const MoviesDetailInitialState();
}

class MoviesDetailLoadingState extends MoviesDetailState {
  const MoviesDetailLoadingState();
}

class MoviesDetailLoadedState extends MoviesDetailState {
  const MoviesDetailLoadedState(
    this.response,
    this.responseImages,
    this.responseSimiliar,
    this.responseCast,
  );
  final MoviesDetail? response;
  final MoviesImages? responseImages;
  final MoviesSimiliar? responseSimiliar;
  final MoviesCasts? responseCast;
  // final MoviesVideos? responseVideos;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MoviesDetailLoadedState &&
        o.response == response &&
        o.responseImages == responseImages &&
        o.responseSimiliar == responseSimiliar &&
        o.responseCast == responseCast;
  }

  @override
  int get hashCode {
    return response.hashCode ^
        responseImages.hashCode ^
        responseSimiliar.hashCode ^
        responseCast.hashCode;
  }
}

class MoviesDetailErrorState extends MoviesDetailState {
  const MoviesDetailErrorState(this.message);
  final String message;
}
