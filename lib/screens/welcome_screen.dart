import 'package:flutter/material.dart';
import 'package:grocery_app/screens/onboard_screen.dart';
import 'package:equatable/equatable.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  get context => null;

  void showBottomSheet(content) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
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
              height: 30,
            ),
            const TextField(
              decoration: InputDecoration(
                prefixText: '+254',
                labelText: '10 digit mobile number',
              ),
              autofocus: true,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              child: const Text('ENTER PHONE NUMBER'),
              onPressed: () {},
            ),
          ],
        ),
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
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
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
