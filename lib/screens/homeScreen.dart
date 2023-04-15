import 'package:flutter/material.dart';
import 'package:grocery_app/providers/auth_provider.dart';
import 'package:grocery_app/services/near_by_store.dart';
import 'package:grocery_app/services/top_pick_store.dart';
import 'package:grocery_app/widgets/image_slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/my_appBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? location;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    setState(() {
      this.location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [const MyAppBar()];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: [
            const ImageSlider(),
            Container(
              color: Colors.white,
              child: const TopPickStore(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: NearByStores(),
            ),
          ],
        ),
      ),
    );
  }
}
