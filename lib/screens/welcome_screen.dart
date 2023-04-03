import 'package:flutter/material.dart';
import 'package:grocery_app/providers/auth_provider.dart';
import 'package:grocery_app/screens/onboard_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'welcome-screen';

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
                      labelText: '10 digit mobile number',
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
                            style: TextButton.styleFrom(
                              backgroundColor: validPhoneNumber
                                  ? Theme.of(context).primaryColor
                                  : Colors.blueGrey,
                            ),
                            child: Text(
                              validPhoneNumber
                                  ? 'CONTINUE'
                                  : 'ENTER PHONE NUMBER',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              String number =
                                  '+254${phoneNumberController.text}';
                              auth.verifyPhone(context, number).then((value) {
                                phoneNumberController.clear();
                              });
                            },
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
      );
    }

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
                  style: TextStyle(color: Colors.deepOrangeAccent),
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
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: const Text(
                    'SET DELIVERY LOCATION',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
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
}
