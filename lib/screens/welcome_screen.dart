import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/providers/auth_provider.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:grocery_app/screens/map_screen.dart';
import 'package:grocery_app/screens/onboard_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    //Debug this
    final auth = Provider.of<AuthProvider>(context);

    bool validPhoneNumber = false;
    var phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: auth.error == 'Invalid OTP' ? true : false,
                    child: Column(
                      children: [
                        Text(
                          auth.error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Enter your phone Number to Proceed',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      prefixText: '+254',
                      labelText: '9 digit mobile number',
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    controller: phoneNumberController,
                    onChanged: (value) {
                      if (value.length == 9) {
                        myState(() {
                          validPhoneNumber = true;
                        });
                      } else {
                        myState(() {
                          validPhoneNumber = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: validPhoneNumber ? false : true,
                          child: TextButton(
                            onPressed: () {
                              myState(() {
                                auth.loading = true;
                              });
                              String number =
                                  '+254${phoneNumberController.text}';
                              auth
                                  .verifyPhone(context: context, number: number)
                                  .then((value) {
                                phoneNumberController.clear();
                                auth.loading = false;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: validPhoneNumber
                                  ? Theme.of(context).primaryColor
                                  : Colors.blueGrey,
                            ),
                            child: auth.loading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    validPhoneNumber
                                        ? 'CONTINUE'
                                        : 'ENTER PHONE NUMBER',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'SKIP',
                  style: TextStyle(color: Color(0xFF84c225)),
                ),
              ),
            ),
            Column(
              children: [
                const Expanded(
                  child: OnBoardScreen(),
                ),
                const Text(
                  'Ready to order from your nearest shop?',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF84c225),
                  ),
                  child: locationData.loading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'SET DELIVERY LOCATION',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () async {
                    setState(() {
                      locationData.loading = true;
                    });
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final bool? isAllowed = prefs.getBool('isAllowed');
                    if (isAllowed == null) {
                      // ignore: use_build_context_synchronously
                      await requestLocationPermission(
                          context, locationData, prefs);
                    } else if (isAllowed == true) {
                      await locationData.getCurrentPosition();
                      if (locationData.permissionAllowed == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, MapScreen.id);
                        setState(() {
                          locationData.loading = false;
                        });
                      } else {
                        if (kDebugMode) {
                          print('permission not allowed');
                          setState(() {
                            locationData.loading = false;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        locationData.loading = false;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      auth.screen = 'Login';
                    });
                    showBottomSheet(context);
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already a Customer?',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> requestLocationPermission(BuildContext context,
      LocationProvider locationData, SharedPreferences prefs) async {
    final LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await prefs.setBool('isAllowed', false);
      setState(() {
        locationData.loading = false;
      });
    } else if (permission == LocationPermission.always) {
      await prefs.setBool('isAllowed', true);
      await locationData.getCurrentPosition();
      if (locationData.permissionAllowed == true) {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
            locationData.latitude, locationData.longitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          locationData.deliveryLocation = placemarks[0];
        }
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, MapScreen.id);
        setState(() {
          locationData.loading = false;
        });
      } else {
        if (kDebugMode) {
          print('permission not allowed');
          setState(() {
            locationData.loading = false;
          });
        }
      }
    }
  }
}
