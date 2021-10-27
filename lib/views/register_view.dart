import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/auth_controller.dart';
import 'package:movies/utils/textStyles.dart';
import 'package:movies/widgets/customTextField.dart';

class RegisterView extends GetWidget<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageLayer(size),
              shadowLayer(size),
              Column(
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
                            'Kayıt Ol',
                            style: titleBigStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          form(),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget form() {
    return GetBuilder<AuthController>(builder: (_controller) {
      return Form(
        key: _controller.registerFormKey,
        child: Column(
          children: [
            CommonTextField(
              isValidate: _controller.isRegisterValidate.value,
              controller: _controller.registerNameController,
              hintText: 'İsim Soyisim',
            ),
            SizedBox(
              height: 10,
            ),
            CommonTextField(
              isValidate: _controller.isRegisterValidate.value,
              controller: _controller.registerEmailController,
              hintText: 'Email',
            ),
            SizedBox(
              height: 10,
            ),
            CommonTextField(
              isValidate: _controller.isRegisterValidate.value,
              controller: _controller.registerPasswordController,
              hintText: 'Şifre',
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                _controller.setRegisterValidate(true);
                if (_controller.registerFormKey.currentState!.validate()) {
                  controller.createUser(
                    controller.registerNameController.text.trim(),
                    controller.registerEmailController.text.trim(),
                    controller.registerPasswordController.text.trim(),
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
                        'Kayıt Ol',
                        style: titleBigStyle,
                      ),
              ),
            )
          ],
        ),
      );
    });
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
