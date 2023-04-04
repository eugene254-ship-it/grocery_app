import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;
  bool permissionAllowed = false;
  // ignore: prefer_typing_uninitialized_variables
  var selectedAddress;
  bool loading = false;

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // ignore: unnecessary_null_comparison
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;

      final coordinates = LatLng(latitude, longitude);
      final addresses = await placemarkFromCoordinates(
          coordinates.latitude, coordinates.longitude);
      selectedAddress = addresses.first;

      permissionAllowed = true;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Permission not allowed');
      }
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    if (kDebugMode) {
      print("${selectedAddress.name} : ${selectedAddress.street}");
    }
  }
}