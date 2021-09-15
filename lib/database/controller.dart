import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:movies/database/db_helper.dart';
import 'package:movies/models/movies_favorite.dart';

class FavoriteController extends GetxController {
  List<MoviesFavorite> favorite = [];
  Rx<List<int?>> movieIds = RxList<int?>().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    refreshNotes();
    super.onInit();
  }

  @override
  void onClose() {
    DatabaseHelper.instance.close();
    super.onClose();
  }

  Future refreshNotes() async {
    isLoading = true.obs;
    favorite = (await DatabaseHelper.instance.readAllFavorites());
    movieIds.value.clear();
    for (var i = 0; i < favorite.length; i++) {
      if (favorite[i].movieId != null) {
        movieIds.value.add(favorite[i].movieId);
      }
    }
    isLoading = false.obs;
    update();
  }

  Future addFavorite(
      int movieId, String title, String imagePath, double voteAverage) async {
    final favorite = MoviesFavorite(
        imagePath: imagePath,
        movieId: movieId,
        title: title,
        voteAverage: voteAverage,
        time: DateTime.now());
    DatabaseHelper.instance.addFavorite(favorite);

    refreshNotes();
  }

  Future deleteFavorite(int? movieID) async {
    if (movieID != null) {
      await DatabaseHelper.instance.delete(movieID);
      refreshNotes();
    }
  }
}
