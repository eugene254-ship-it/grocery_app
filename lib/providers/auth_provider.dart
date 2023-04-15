// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:grocery_app/services/user_services.dart';
import 'package:geocoding/geocoding.dart';

import '../screens/homeScreen.dart';
import '../screens/landing_screen.dart';
import '../screens/main_screen.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String smsOtp;
  late String verificationId;
  String error = '';
  final UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  late String screen;
  double latitude = 0.0;
  double longitude = 0.0;
  String address = '';
  String location = '';

  Future<void> verifyPhone({BuildContext? context, String? number}) async {
    loading = true;
    notifyListeners();

    verificationCompleted(PhoneAuthCredential credential) async {
      loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException e) {
      error = e.toString();
      notifyListeners();
      loading = false;
      if (kDebugMode) {
        print(e.code);
      }
    }

    smsOtpSend(String verId, int? resendToken) {
      verificationId = verId;
      smsOtpDialog(context!, number!);
    }

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> smsOtpDialog(BuildContext context, String number) async {
    String smsOtp = '';
    BuildContext dialogContext = context;
    return showDialog<void>(
      context: dialogContext,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(
                children: const [
                  Text('Verification Code'),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Enter 6 digit OTP received as SMS',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              content: SizedBox(
                height: 85,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) {
                    setState(() {
                      smsOtp = value;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);

                      final User? user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;

                      if (user != null) {
                        loading = false;
                        notifyListeners();

                        _userServices.getUserById(user.uid).then((snapShot) {
                          if (snapShot.exists) {
                            if (screen == 'Login') {
                              // need to check user data
                              if ((snapShot.data()
                                      as Map<String, dynamic>)['address'] !=
                                  null) {
                                Navigator.pushReplacementNamed(
                                    context, MainScreen.id);
                              }
                              Navigator.pushReplacementNamed(
                                  dialogContext, LandingScreen.id);
                            } else {
                              updateUser(
                                  id: user.uid, number: user.phoneNumber);
                              Navigator.pushReplacementNamed(
                                  dialogContext, MainScreen.id);
                            }
                          } else {
                            createUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                dialogContext, LandingScreen.id);
                          }
                        });
                      } else {
                        if (kDebugMode) {
                          print('Login failed');
                        }
                      }
                    } catch (e) {
                      error = 'Invalid OTP';
                      notifyListeners();
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('DONE'),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      loading = false;
      notifyListeners();
    });
  }

  void createUser({String? id, String? number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'location': location
    });
    loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    String? id,
    String? number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'location': location
      });
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error $e');
      }
      return false;
    }
  }
}
