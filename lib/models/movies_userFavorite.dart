import 'package:cloud_firestore/cloud_firestore.dart';

class UserFavorite {
  UserFavorite({this.data});
  List<FavoriteData>? data;
  UserFavorite.fromDataBase({DocumentSnapshot? documentSnapshot}) {
    data:
    documentSnapshot == null
        ? null
        : List<FavoriteData>.from(documentSnapshot['data']
            .map((x) => FavoriteData.fromDataBase(documentSnapshot: x)));
  }
}

class FavoriteData {
  int? id;
  String? title;
  String? imagePath;
  double? voteAverage;

  FavoriteData({this.id, this.title, this.imagePath, this.voteAverage});
  FavoriteData.fromDataBase({DocumentSnapshot? documentSnapshot}) {
    id:
    documentSnapshot?['id'];
    title:
    documentSnapshot?['title'];
    imagePath:
    documentSnapshot?['image_path'];
    voteAverage:
    documentSnapshot?['vote_average'];
  }
}
