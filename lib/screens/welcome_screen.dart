// ignore_for_file: must_be_immutable, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:grocery_app/screens/onboard_screen.dart';
import 'package:equatable/equatable.dart';

class WelcomeScreen extends StatelessWidget {
  bool _validPhoneNumber = false;

  WelcomeScreen({super.key});

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
                  onChanged: (value) {
                    if (value.length == 9) {
                      myState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      myState(() {
                        _validPhoneNumber = false;
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
                        absorbing: _validPhoneNumber ? false : true,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: _validPhoneNumber
                                ? Theme.of(context).primaryColor
                                : Colors.blueGrey,
                          ),
                          child: Text(
                            _validPhoneNumber
                                ? 'CONTINUE'
                                : 'ENTER PHONE NUMBER',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
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
