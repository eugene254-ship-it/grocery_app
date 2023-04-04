import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_app/providers/location_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;
  late GoogleMapController mapController;
  bool locating = false;

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    currentLocation = LatLng(locationData.latitude, locationData.longitude);

    void onCreated(GoogleMapController controller) {
      setState(() {
        mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: currentLocation != null
                  ? CameraPosition(
                      target: currentLocation!,
                      zoom: 14.4746,
                    )
                  : const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 1,
                    ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 40),
                child: Image.asset('images/pin.png'),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locating
                        ? const LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : Container(),
                    TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.location_searching,
                          color: Colors.red,
                        ),
                        label: locating
                            ? const Text('Locating...')
                            : Text(
                                locating
                                    ? 'Locating...'
                                    : locationData
                                            .selectedAddress?.featureName ??
                                        '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              )),
                    Text(locationData.selectedAddress?.addressLine ?? ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
