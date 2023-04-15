// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:grocery_app/providers/auth_provider.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:grocery_app/providers/store_provider.dart';
import 'package:grocery_app/screens/homeScreen.dart';
import 'package:grocery_app/screens/landing_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/main_screen.dart';
import 'package:grocery_app/screens/map_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primaryColor: const Color(0xFF84c225), fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        MapScreen.id: (context) => const MapScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        LandingScreen.id: (context) => const LandingScreen(),
        MainScreen.id: (context) => const MainScreen(),
      },
    );
  }
}
