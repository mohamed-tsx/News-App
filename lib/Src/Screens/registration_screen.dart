import 'package:flutter/material.dart';
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
              hintText: "email@example.com",
              controller: emailController,
              formkey: emailFormKey,
              obsecureText: false,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomTextFeild(
              hintText: "password",
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
