import 'package:flutter/material.dart';
import '../view_model/login_view_model.dart';

class UserLoginView extends StatelessWidget {
  const UserLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: LoginViewModel());
  }
}
