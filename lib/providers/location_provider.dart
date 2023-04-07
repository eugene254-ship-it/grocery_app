import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  late double latitude = 0.0;
  late double longitude = 0.0;
  bool permissionAllowed = false;
  Placemark? selectedAddress;
  bool loading = false;

  Future<void> getCurrentPosition() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // ignore: unnecessary_null_comparison
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      selectedAddress = placemarks.first;

      permissionAllowed = true;
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('Permission not allowed');
      }
    }
  }

  void onCameraMove(CameraPosition cameraPosition) {
    latitude = cameraPosition.target.latitude;
    longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    if (selectedAddress != null) {
      List<Location> addresses = await locationFromAddress(
          '1600 Amphitheatre Parkway, Mountain View, CA');
      Location selectedLocation = addresses.first;
      List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation.latitude, selectedLocation.longitude);
      selectedAddress = placemarks.first;

      if (kDebugMode) {
        print("${selectedAddress!.name} : ${selectedAddress!.street}");
      }
    }
  }
}
