import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Src/Components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/Src/Components/text_field.dart';
import 'package:news_app/Src/Screens/home_screen.dart';
import 'package:news_app/Src/Screens/registration_completion_screen.dart';
import 'package:news_app/Src/Screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  Future<void> logInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Ensure user is authenticated before checking Firestore
      if (userCredential.user != null) {
        bool userExists =
            await checkUserInDatabase(context, emailController.text.trim());
        if (userExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged in Successfully"),
            ),
          );
        } else {
          return; // Stop further execution if user is not found
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to sign in: ${e.toString()}"),
          ),
        );
      }
    }
  }

  Future<bool> checkUserInDatabase(BuildContext context, String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      return true; // User found
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationCompletionScreen(),
        ),
      );
      return false; // User not found
    }
  }

  @override
  Widget build(BuildContext context) {
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
              text: "Login",
              onTap: () => logInWithEmailAndPassword(context),
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
