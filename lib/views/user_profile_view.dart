import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/auth_controller.dart';

import '../utils/textStyles.dart';

class UserProfileView extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (_controller) {
            return Column(children: [
              Center(
                child: InkWell(
                  onTap: () {
                    controller.signOut();
                    controller.userFavoriteIds.clear();
                  },
                  child: Text(
                    'Çıkış Yap',
                    style: titleStyle,
                  ),
                ),
              ),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? 'aa',
                style: titleStyle,
              )
            ]);
          },
        ),
      ),
    );
  }
}
