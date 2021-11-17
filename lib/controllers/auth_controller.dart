import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/models/movies_detail.dart';
import 'package:movies/services/movies_services.dart';
import 'package:movies/views/bottomNavBar_view.dart';
import 'package:movies/widgets/user_favorites_card_widget.dart';

import '../models/user_model.dart';

import '../services/auth_service.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService _authService = AuthService();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Rxn<User?>? firebaseUser = Rxn<User?>();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  Rx<UserModel?> userModel = UserModel().obs;
  Rx<MoviesDetail?> movieDetail = MoviesDetail().obs;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerPasswordComfirmController =
      TextEditingController();
  TextEditingController registerNameController = TextEditingController();

  RxBool? root = false.obs;
  RxString? deneme = ''.obs;
  RxBool loginLoading = false.obs;
  RxBool registerLoading = false.obs;
  RxBool isLoginValidate = false.obs;
  RxBool isRegisterValidate = false.obs;
  RxList<int> userFavoriteIds = <int>[].obs;

  RxList<Map<String, dynamic>> userFavorites = <Map<String, dynamic>>[].obs;
  Stream<DocumentSnapshot> get favorites => _firebaseFirestore
      .collection('favorites')
      .doc(_auth.currentUser?.uid)
      .snapshots();

  @override
  onInit() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
        firebaseUser?.value = null;

        setRoot(false);
        deneme?.value = 'Rx Denemesi';
        print(deneme?.value);
        update();
      } else {
        print('User is signed in!');
        firebaseUser?.value = _auth.currentUser;
        print("Deneme : ${firebaseUser?.value?.uid}");
        await getUserFromFirebase();
        print('Usermodel Email : ${userModel.value?.email}');
        deneme?.value = 'Rx Denemesi';
        print(deneme?.value);
        setRoot(true);
        update();
      }
    });
  }

  Future setUserFavoriteIds(List<dynamic>? data) async {
    userFavoriteIds.clear();
    print('gelen data = $data');

    if (data != null) {
      for (var i = 0; i < data.length; i++) {
        userFavoriteIds.add(data[i]['id']);
      }
    }
  }

  printSomething(String yazi) {
    print(yazi);
  }

  Future addFavorite(
      int id, dynamic vote, String title, String imagePath) async {
    try {
      Map<String, dynamic> data = {
        'title': title,
        'id': id,
        'vote_average': vote,
        'image_path': imagePath
      };
      await _firebaseFirestore
          .collection('favorites')
          .doc(_auth.currentUser?.uid)
          .update({
        'data': FieldValue.arrayUnion([data])
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
    update();
  }

  Future removeFavorite(
      int id, dynamic vote, String title, String imagePath) async {
    try {
      Map<String, dynamic> data = {
        'title': title,
        'id': id,
        'vote_average': vote,
        'image_path': imagePath
      };
      await _firebaseFirestore
          .collection('favorites')
          .doc(_auth.currentUser?.uid)
          .update({
        'data': FieldValue.arrayRemove([data])
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
    if (userFavoriteIds.length == 1) {
      userFavoriteIds.clear();
    }
    update();
  }

  Future getMovieDetail(int? movieId) async {
    if (movieId != null) {
      movieDetail.value = await MoviesService().getMovieDetail(movieId);
      update();
    } else {
      print('Hata oluştu - Film id : $movieId');
    }
    update();
  }

  getUserFromFirebase() async {
    userModel.value =
        await _authService.getUserFromFirebase(_auth.currentUser?.uid);
    update();
  }

  signOut() async {
    await _authService.signOut();
    userModel.value = UserModel();
    update();
  }

  setRoot(bool value) {
    root?.value = value;
    update();
  }

  setLoginValidate(bool value) {
    isLoginValidate.value = value;
    update();
  }

  setRegisterValidate(bool value) {
    isRegisterValidate.value = value;
    update();
  }

  Future<void> createUser(String? name, String? email, String? password) async {
    try {
      if (name != null && email != null && password != null) {
        registerLoading.value = true;
        UserCredential? _userResult = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        userModel.value =
            await _authService.getUserFromFirebase(_userResult.user?.uid);
        print("Firebase User bilgileri Email :  ${_userResult.user?.email}");

        if (_userResult.user?.uid != userModel.value?.id) {
          Map<String, dynamic> userData = {
            'email': email,
            'name': name,
            'favoriteMovies': [],
          };
          Map<String, dynamic> favoriteData = {
            'data': [],
          };
          await _firebaseFirestore
              .collection('users')
              .doc(_userResult.user?.uid)
              .set(userData);
          await _firebaseFirestore
              .collection('favorites')
              .doc(_userResult.user?.uid)
              .set(favoriteData);
          update();
          if (_auth.currentUser?.uid != null) {
            Get.offAll(BottomNavBar());
          }
        } else {
          Get.snackbar(
            "Lütfen Boş alan bırakmayınız",
            "Boş alanları doldurunuz",
            snackPosition: SnackPosition.TOP,
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Colors.white,
          );
        }
        update();
      } else {
        update();
      }
    } on FirebaseException catch (e) {
      print('$e : Kayıt olunurken bir hata oluştu');
      Get.snackbar(
        "Error creating Account",
        e.message.toString(),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.white,
      );
    }
    update();
  }

  Future<void> login(String email, String password) async {
    try {
      loginLoading.value = true;
      update();
      UserCredential? _userResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userModel.value =
          await _authService.getUserFromFirebase(_userResult.user?.uid);
      print("Firebase User bilgileri Email :  ${_userResult.user?.email}");
      loginEmailController.clear();
      loginPasswordController.clear();

      loginLoading.value = false;
      update();
      if (_auth.currentUser?.uid != null) {
        Get.offAll(BottomNavBar());
      }
    } on FirebaseException catch (e) {
      loginLoading.value = false;
      print(e);
      Get.snackbar(
        "Error signing in",
        e.message.toString(),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.white,
      );
    }
    update();
  }

  Future signInWithGoogle() async {
    try {
      await _authService.signInwithGoogle().then((googleUser) async {
        print(googleUser?.uid);
        userModel.value =
            await _authService.getUserFromFirebase(googleUser?.uid);
        if (userModel.value?.id != googleUser?.uid) {
          Map<String, dynamic> userData = {
            'email': googleUser?.email,
            'name': googleUser?.displayName,
            'favoriteMovies': [],
          };
          Map<String, dynamic> favoriteData = {
            'data': [],
          };
          print("Firebase User bilgileri Email :  ${googleUser?.email}");
          await _firebaseFirestore
              .collection('users')
              .doc(googleUser?.uid)
              .set(userData);
          await _firebaseFirestore
              .collection('favorites')
              .doc(googleUser?.uid)
              .set(favoriteData);
          update();
        } else {
          print('kullanıcı zaten kayıtlı');
        }
        if (_auth.currentUser?.uid != null) {
          Get.offAll(BottomNavBar());
        }
      });
    } catch (e) {
      print('Kayıt oluştururken hata if else : $e');
    }

    update();
  }
}
