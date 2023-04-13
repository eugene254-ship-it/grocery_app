import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:grocery_app/screens/homeScreen.dart';
import 'package:grocery_app/screens/landing_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth_provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  const MapScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation = const LatLng(-1.285790, 36.820030);
  late GoogleMapController mapController;
  bool locating = false;
  bool loggedIn = false;
  User? user;

  @override
  void initState() {
    //check user logged in or not, while opening Map Screen
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    currentLocation = LatLng(locationData.latitude, locationData.longitude);

    void onCreated(GoogleMapController controller) {
      setState(() {
        mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: currentLocation != null
                  ? CameraPosition(
                      target: currentLocation!,
                      zoom: 14.4746,
                    )
                  : const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 1,
                    ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 40),
                child: Image.asset(
                  'assets/images/pin.png',
                  color: Colors.black,
                ),
              ),
            ),
            const Center(
              child: SpinKitPulse(
                color: Colors.black54,
                size: 100.0,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locationData.loading
                        ? const LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: TextButton.icon(
                        onPressed: () async {
                          await locationData.getCurrentPosition();
                        },
                        icon: const Icon(
                          Icons.location_searching,
                          color: Colors.red,
                        ),
                        label: Flexible(
                          child: Text(
                            locationData.loading
                                ? 'Locating....'
                                : locationData.selectedAddress?.name ??
                                    'Choose location',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        locationData.loading
                            ? ''
                            : locationData.selectedAddress?.street ?? '',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: AbsorbPointer(
                          absorbing: locationData.loading,
                          child: TextButton(
                            onPressed: () {
                              //save address in shared Preferences
                              locationData.savePrefs();
                              if (loggedIn == false) {
                                Navigator.pushNamed(context, LoginScreen.id);
                              } else {
                                setState(() {
                                  auth.latitude = locationData.latitude;
                                  auth.longitude = locationData.longitude;
                                  auth.address =
                                      locationData.selectedAddress?.street ??
                                          '';
                                  auth.location =
                                      locationData.selectedAddress?.name ?? '';
                                });
                                if (kDebugMode) {
                                  print(user!.uid);
                                }
                                auth
                                    .updateUser(
                                  id: user!.uid,
                                  number: user!.phoneNumber,
                                )
                                    .then((value) {
                                  if (value == true) {
                                    Navigator.pushNamed(context, HomeScreen.id);
                                  }
                                });
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                locationData.loading ? Colors.grey : Colors.red,
                              ),
                            ),
                            child: const Text(
                              'CONFIRM LOCATION',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
