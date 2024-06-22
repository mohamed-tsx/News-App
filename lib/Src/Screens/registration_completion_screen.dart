import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/Src/Screens/home_screen.dart';
import 'package:news_app/Src/Components/button.dart';
import 'package:news_app/Src/Components/text_field.dart';

class RegistrationCompletionScreen extends StatefulWidget {
  @override
  _RegistrationCompletionScreenState createState() =>
      _RegistrationCompletionScreenState();
}

class _RegistrationCompletionScreenState
    extends State<RegistrationCompletionScreen> {
  TextEditingController nameController = TextEditingController();
  final nameFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "In order to continue complete registration",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              CustomTextFeild(
                hintText: "What's Your Name",
                controller: nameController,
                formkey: nameFormKey,
                obsecureText: false,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onTap: completeRegistration,
                text: "Complete Registration",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> completeRegistration() async {
    try {
      print("Starting registration process");

      // Get current user
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw FirebaseAuthException(
            message: 'User is not authenticated', code: '');
      }

      print("User authenticated: ${currentUser.uid}");

      if (nameController.text.isNotEmpty) {
        // Check if user document exists in Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (!userDoc.exists) {
          print("User document does not exist, creating new document");
          // If user document does not exist, create it
          await _firestore.collection('users').doc(currentUser.uid).set({
            'name': nameController.text,
            'email': currentUser.email,
            // Add other fields as needed
          });
        } else {
          print("User document already exists");
        }

        // Navigate to next screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        print("Form validation failed");
      }
    } catch (e) {
      // Handle registration errors
      print('Failed to complete registration: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
        ),
      );
    }
  }
}
