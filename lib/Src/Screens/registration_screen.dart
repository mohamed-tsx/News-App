import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_app/Src/Components/text_field.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final emailFormKey = GlobalKey<FormState>();
    final passwordFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFeild(
              hintText: "hintText",
              controller: emailController,
              formkey: emailFormKey,
              obsecureText: false,
            ),
            SizedBox(
              height: 7,
            ),
            CustomTextFeild(
              hintText: "hintText",
              controller: passwordController,
              formkey: passwordFormKey,
              obsecureText: true,
            ),
          ],
        ),
      ),
    );
  }
}
