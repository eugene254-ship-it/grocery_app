// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:grocery_app/constants.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final controller = PageController(
  initialPage: 0,
);

int currentPage = 0;

List<Widget> pages = [
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/deliveryicon.png')),
      const Text(
        'Set Your Delivery Location',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(
          child: Image.asset('assets/images/Pudge.png')), // corrected file name
      const Text(
        'Order Online from Your Favourite Store',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/deliverfood.png')),
      const Text(
        'Quick Deliver to your Doorstep',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            children: pages,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        DotsIndicator(
          dotsCount: pages.length,
          position: currentPage.toDouble(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              activeColor: const Color(0xFF84c225)),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
