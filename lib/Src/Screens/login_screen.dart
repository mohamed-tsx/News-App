import 'package:flutter/material.dart';
import 'package:news_app/Src/Components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/Src/Components/text_field.dart';
import 'package:news_app/Src/Screens/home_screen.dart';
import 'package:news_app/Src/Screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final emailFormKey = GlobalKey<FormState>();
    final passwordFormKey = GlobalKey<FormState>();

    Future<void> logInWithEmailAndPassword() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Navigate to the next screen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        // const users = await
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logged in Succefully"),
          ),
        );
      } catch (e) {
        // Show error message if sign-in fails
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to sign in: ${e.toString()}"),
            ),
          );
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Log in to your account now",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 8,
            ),
            CustomButton(
              text: "Register",
              onTap: () => logInWithEmailAndPassword(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Don't have an Account?"),
                  const SizedBox(
                    width: 7,
                  ),
                  GestureDetector(
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
