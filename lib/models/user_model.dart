import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;

  String? email;
  List? favorites;

  UserModel({
    this.id,
    this.name,
    this.email,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot? documentSnapshot}) {
    id = documentSnapshot?.id;
    name = documentSnapshot?["name"];

    email = documentSnapshot?["email"];
    favorites = documentSnapshot?["favoriteMovies"];
  }
}
