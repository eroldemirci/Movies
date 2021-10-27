import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../views/login_view.dart';
import '../views/user_profile_view.dart';

class IsSignedInRooter extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_control) {
      if (_control.firebaseUser?.value != null) {
        return UserProfileView();
      } else {
        return UserLoginView();
      }
    });
  }
}
