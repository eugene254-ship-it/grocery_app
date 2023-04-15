import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text('sign Out'),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        },
      )),
    );
  }
}
