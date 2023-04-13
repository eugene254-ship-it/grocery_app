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
  User? user = FirebaseAuth.instance.currentUser;
  String? _location;
  String? _address;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      UserServices userServices = UserServices();
      userServices.getUserById(user!.uid).then((result) async {
        if (result != null) {
          Map<String, dynamic> data =
              result.data() as Map<String, dynamic>; // fix is here
          if (data['latitude'] != null) {
            getPrefs(result);
          } else {
            locationProvider.getCurrentPosition();
            if (locationProvider.permissionAllowed == true) {
              Navigator.pushNamed(context, MapScreen.id);
            } else {
              if (kDebugMode) {
                print('Permission not allowed');
              }
            }
          }
        }
      });
    }
  }

  getPrefs(dbResult) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    if (location == null) {
      prefs.setString('address', dbResult.data()!['address']);
      prefs.setString(
          'location', dbResult.data()!['latitude'].toString()); // Fix is here
      if (mounted) {
        setState(() {
          _location = dbResult.data()!['latitude'].toString(); // Fix is here
          _address = dbResult.data()!['address'];
          loading = false;
        });
      }
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_location == null ? '' : _location!),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _address == null ? 'Delivery Address not set' : _address!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _address == null
                    ? 'Please update your Delivery Location to find nearest Stores for you'
                    : _address!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const CircularProgressIndicator(),
            SizedBox(
                width: 600,
                child: Image.asset(
                  'assets/images/',
                  fit: BoxFit.fill,
                  color: Colors.black12,
                )),
            Visibility(
              visible: _location != null ? true : false,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    elevation: 2,
                    backgroundColor: Colors.amber),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                },
                child: const Text('Confirm Your Location'),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  elevation: 2,
                  backgroundColor: Colors.amber),
              onPressed: () {
                locationProvider.getCurrentPosition();
                if (locationProvider.selectedAddress != null) {
                  Navigator.pushReplacementNamed(context, MapScreen.id);
                } else {
                  if (kDebugMode) {
                    print('Permission not allowed');
                  }
                }
              },
              child: Text(
                _location != null ? 'Update Location' : 'Confirm Your Location',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
