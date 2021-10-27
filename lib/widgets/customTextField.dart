import 'package:flutter/material.dart';
import 'package:movies/controllers/auth_controller.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.isValidate,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final bool? isValidate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidate: isValidate ?? false,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Lütfen boş alan bırakmayınız';
        } else {
          return null;
        }
      },
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          color: Colors.grey[850],
        ),
        hoverColor: Colors.grey[850],
        labelStyle: TextStyle(
          color: Colors.grey[850],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
