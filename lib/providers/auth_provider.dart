import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/services/user_services.dart';

import '../screens/homeScreen.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String smsOtp;
  late String verificationId;
  String error = '';
  final UserServices _userServices = UserServices();

  Future<void> verifyPhone(BuildContext context, String number) async {
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException e) {
      if (kDebugMode) {
        print(e.code);
      }
    }

    smsOtpSend(String verId, int? resendToken) {
      verificationId = verId;
      smsOtpDialog(context, number);
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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: const [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OTP recieved as SMS',
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
                  smsOtp = value;
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

                    final User? user =
                        (await _auth.signInWithCredential(phoneAuthCredential))
                            .user;
                    //create user data
                    _createUser(id: user?.uid, number: user?.phoneNumber);
                    //navigate
                    if (user != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                    } else {
                      if (kDebugMode) {
                        print('Login Failed');
                      }
                    }
                  } catch (e) {
                    error = 'Invalid OTP';
                    notifyListeners();
                    if (kDebugMode) {
                      print(e.toString());
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('DONE'),
              ),
            ],
          );
        });
  }

  void _createUser({String? id, String? number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
    });
  }
}
