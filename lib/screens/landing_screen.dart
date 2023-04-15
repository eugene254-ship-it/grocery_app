import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:grocery_app/screens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_services.dart';
import 'homeScreen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not set',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please update your Delivery Location to find nearest Stores for you',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const CircularProgressIndicator(),
            SizedBox(
                width: 600,
                child: Image.asset(
                  'assets/images/city.png',
                  fit: BoxFit.fill,
                  color: Colors.black12,
                )),
            TextButton(
              style: TextButton.styleFrom(
                  elevation: 2, backgroundColor: const Color(0xFF84c225)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              },
              child: const Text('Confirm Your Location'),
            ),
            _loading
                ? const CircularProgressIndicator()
                : TextButton(
                    style: TextButton.styleFrom(
                        elevation: 2, backgroundColor: const Color(0xFF84c225)),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });

                      await locationProvider.getCurrentPosition();
                      if (locationProvider.permissionAllowed == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(const Duration(seconds: 4), () {
                          if (locationProvider.permissionAllowed == false) {
                            if (kDebugMode) {
                              print('Permission not allowed');
                            }
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'Please allow permission to find nearest stores for you'),
                            ));
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Set Your Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
