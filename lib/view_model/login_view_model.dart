import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/views/register_view.dart';
import 'package:movies/widgets/customTextField.dart';
import '../controllers/auth_controller.dart';

import '../utils/textStyles.dart';

class LoginViewModel extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageLayer(size),
            shadowLayer(size),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Container(
                      width: size.width * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Giriş Yap',
                            style: titleBigStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          emailPasswordForm(),
                          SizedBox(
                            height: 20,
                          ),
                          googleSignInButton(size),
                          SizedBox(
                            height: 50,
                          ),
                          registerRow(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget registerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            'Hesabın yok mu?',
            style: normalTextStyle,
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Flexible(
          child: TextButton(
            onPressed: () {
              Get.to(RegisterView());
            },
            child: Text(
              'Kayıt Ol',
              style: registerTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget emailPasswordForm() {
    return GetBuilder<AuthController>(builder: (_controller) {
      return Form(
        key: _controller.loginFormKey,
        child: Column(
          children: [
            CommonTextField(
              isValidate: _controller.isLoginValidate.value,
              controller: _controller.loginEmailController,
              hintText: 'Email',
            ),
            SizedBox(
              height: 10,
            ),
            CommonTextField(
              isValidate: _controller.isLoginValidate.value,
              controller: _controller.loginPasswordController,
              hintText: 'Şifre',
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                _controller.setLoginValidate(true);
                if (_controller.loginFormKey.currentState!.validate()) {
                  _controller.login(
                    _controller.loginEmailController.text.trim(),
                    _controller.loginPasswordController.text.trim(),
                  );
                }
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _controller.loginLoading.value == true
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Giriş Yap',
                        style: titleBigStyle,
                      ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget googleSignInButton(Size size) {
    return InkWell(
      onTap: () {
        controller.signInWithGoogle();
      },
      child: Container(
        height: 60,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/assets/images/google_logo.png',
              height: 40,
              width: 40,
            ),
            Text(
              'Google ile devam et',
              style: titleBlackStyle,
            ),
          ],
        ),
      ),
    );
  }

  Container shadowLayer(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.black.withOpacity(0.55),
          Colors.black54.withOpacity(0.85),
          Colors.black.withOpacity(0.85)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 0.5, 1],
      )),
    );
  }

  Container imageLayer(Size size) {
    return Container(
      height: size.height,
      width: size.width,
      child: Image.asset(
        'lib/assets/images/posters_background.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
