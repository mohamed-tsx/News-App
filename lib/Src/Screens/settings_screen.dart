import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Src/Components/button.dart';
import 'package:news_app/Src/Components/text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = "Loading...";
  List<Map<String, dynamic>> newsArticles = [];

  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'No name';
        });
      }
    }
  }

  Future<void> _updateName() async {
    if (nameController.text.isNotEmpty) {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String newName = nameController.text.trim();
        await _firestore.collection('users').doc(currentUser.uid).update({
          'name': newName,
        });
        setState(() {
          userName = newName;
        });
        nameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Name updated successfully')),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).delete();
      await currentUser.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );
      Navigator.of(context).popUntil(
          (route) => route.isFirst); // Navigate back to the home screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text("Hi Guys 👋 it's $userName"),
              const SizedBox(height: 70),
              CustomTextFeild(
                hintText: "Change Your name",
                controller: nameController,
                formkey: nameFormKey,
                obsecureText: false,
              ),
              const SizedBox(height: 10),
              CustomButton(
                onTap: _updateName,
                text: "Update name",
              ),
              const SizedBox(height: 70),
              CustomButton(
                onTap: _deleteAccount,
                text: "Delete Account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
