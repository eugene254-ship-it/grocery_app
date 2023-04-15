import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/landing_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_services.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash-screen';

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Wait for 1 second before checking the user's authentication state
    Timer(const Duration(seconds: 1), checkAuthenticationState);
  }

  Future<void> checkAuthenticationState() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    } else {
      getUserData();
    }
  }

  getUserData() async {
    UserServices userServices = UserServices();
    userServices.getUserById(user!.uid).then((result) {
      // Check Location details
      if ((result.data() as Map<String, dynamic>)['address'] != null) {
        // if address details exists
        updatePrefs(result.data() as Map<String, dynamic>);
      } else {
        // if address details does not exist
        Navigator.pushReplacementNamed(context, LandingScreen.id);
      }
    });
  }

  Future<void> updatePrefs(Map<String, dynamic> result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude'] as double);
    prefs.setDouble('longitude', result['longitude'] as double);
    prefs.setString('address', result['address'] as String);
    prefs.setString('location', result['location'] as String);
    //after update prefs
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/logo.png'),
            const SizedBox(height: 16),
            const Text(
              'Grocery Store',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
