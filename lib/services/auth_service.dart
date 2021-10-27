import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/controller.dart';
import '../models/user_model.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  FavoriteController _controller = Get.put(FavoriteController());
  GoogleSignInAuthentication? googleAuth;
  GoogleSignInAccount? googleUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> loginWithEmail(String? email, String? password) async {
    if (email != null && password != null) {
      UserCredential? _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userCredential.user;
    }
  }

  Future createUser(String email, String password) async {
    try {
      UserCredential? result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return result;
    } on PlatformException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel?> getUserFromFirebase(String? uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();
      if (_doc.exists) {
        return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
      } else {
        return UserModel();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      UserCredential? _googleUser =
          await _auth.signInWithCredential(credential);

      return _googleUser.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // Stream<List<int>> favoriteMoviesStream(String? uid){
  //   return _firestore.collection('users').doc(uid).
  // }

  signOut() async {
    try {
      await _auth.signOut();

      await _googleSignIn.signOut();

      Get.snackbar(
        "SignOut Successfull",
        'Başarıyla çıkış yapıldı',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseException catch (e) {
      print(e);
      Get.snackbar(
        "Error signing out",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
