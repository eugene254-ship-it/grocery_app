import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/services/user_services.dart';

import '../screens/welcome_screen.dart';
import '../services/store_services.dart';

class StoreProvider with ChangeNotifier {
  final StoreServices _storeServices = StoreServices();
  final UserServices _userServices = UserServices();
  final User? user = FirebaseAuth.instance.currentUser;
  double userLatitude = 0.0;
  double userLongitude = 0.0;

  Future<void> getUserLocationData(BuildContext context) async {
    if (user == null) {
      return;
    }

    final result = await _userServices.getUserById(user!.uid);

    if (result.exists) {
      final userData = result.data() as Map<String, dynamic>;
      if (userData['latitude'] != null && userData['longitude'] != null) {
        userLatitude = userData['latitude'];
        userLongitude = userData['longitude'];
        notifyListeners();
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }
  }
}
