import 'package:flutter/material.dart';
import 'package:grocery_app/providers/auth_provider.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  const LoginScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool validPhoneNumber = false;
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 3,
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
                    setState(() {
                      validPhoneNumber = true;
                    });
                  } else {
                    setState(() {
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
                          setState(() {
                            auth.loading = true;
                            auth.screen = 'MapScreen';
                            auth.latitude = locationData.latitude;
                            auth.longitude = locationData.longitude;
                            auth.address =
                                locationData.selectedAddress?.street ?? '';
                          });
                          String number = '+254${phoneNumberController.text}';
                          auth
                              .verifyPhone(
                            context: context,
                            number: number,
                          )
                              .then((value) {
                            phoneNumberController.clear();
                            setState(() {
                              auth.loading = false; //disable loading indicator
                            });
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: validPhoneNumber
                              ? Theme.of(context).primaryColor
                              : Colors.blueGrey,
                        ),
                        child: auth.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
        ),
      ),
    );
  }
}
