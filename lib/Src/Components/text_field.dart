import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final controller;
  final formkey;
  const CustomTextFeild({
    super.key,
    required this.hintText,
    required this.controller,
    required this.formkey,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: obsecureText,
        key: formkey,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter a value";
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 3,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.grey[100],
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
