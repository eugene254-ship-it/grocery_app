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

final _controller = PageController(
  initialPage: 1,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('images/deliveryicon.png')),
      const Text(
        'Set Your Delivery Location',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/Pudge.png')),
      const Text(
        'Order Online from Your Favourite Store',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/deliverfood.png')),
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
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              activeColor: Colors.deepOrangeAccent),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
