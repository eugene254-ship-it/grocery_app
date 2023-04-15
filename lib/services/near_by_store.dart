// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/services/store_services.dart';

import 'package:provider/provider.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
// ignore: unused_import
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
// ignore: unused_import
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';
import '../providers/store_provider.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';

class NearByStores extends StatefulWidget {
  const NearByStores({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NearByStoresState createState() => _NearByStoresState();
}

class _NearByStoresState extends State<NearByStores> {
  var userLocation = {'latitude': '', 'longitude': ''};

  final StoreServices _storeServices = StoreServices();
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  @override
  Widget build(BuildContext context) {
    final storeData = Provider.of<StoreProvider>(context);
    storeData.getUserLocationData(context);

    String getDistance(location, longitude) {
      var distance = Geolocator.distanceBetween(storeData.userLatitude,
          storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000; //this will show in kilometer
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getNearByStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) return const CircularProgressIndicator();
          List shopDistance = [];
          for (int i = 0; i < snapShot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                storeData.userLatitude,
                storeData.userLongitude,
                snapShot.data!.docs[i]['location'].latitude,
                snapShot.data!.docs[i]['location'].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (shopDistance[0] > 10) {
            return Container(
              color: Colors.red,
              child: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 30, top: 30, left: 20, right: 20),
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          'Currently we are not servicing this area,\nPlease Try another location',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    'assets/images/city.png',
                    color: Colors.black12,
                  ),
                  Positioned(
                    right: 10.0,
                    top: 80,
                    child: SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Made by : ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              'Ginsky',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.grey),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            );
          }
          return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      // ignore: prefer_typing_uninitialized_variables
                      var refreshedChangeListener;
                      refreshedChangeListener.refreshed = true;
                    },
                    child: PaginateFirestore(
                        bottomLoader: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                        header: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 8, right: 8, top: 20),
                              child: Text(
                                'All Nearby Stores',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, bottom: 10),
                              child: Text(
                                'Find out quality products near you',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilderType: PaginateBuilderType.listView,
                        itemBuilder: (index, context, document) => Padding(
                              padding: const EdgeInsets.all(4),
                              child: SizedBox(
                                width: MediaQuery.of(context as BuildContext)
                                    .size
                                    .width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Card(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            (document as Map<String, dynamic>)[
                                                'imageUrl'], // cast document as Map<String, dynamic>
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (document as Map<String, dynamic>)[
                                              'shopName'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          (document as Map<String, dynamic>)[
                                              'dialog'],
                                          style: kStoreCardStyle,
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(
                                                      context as BuildContext)
                                                  .size
                                                  .width -
                                              250,
                                          child: Text(
                                            (document as Map<String, dynamic>)[
                                                'address'],
                                            overflow: TextOverflow.ellipsis,
                                            style: kStoreCardStyle,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '${getDistance(Map<String, dynamic>.from(document as Map)['location'], userLocation)}Km',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                        query: _storeServices.getNearByStorePagination(),
                        isLive: true,
                        listeners: [
                          refreshChangeListener,
                        ],
                        footer: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Stack(
                            children: [
                              const Center(
                                child: Text(
                                  '**That\s all folks**',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Image.asset(
                                'assets/images/city.png',
                                color: Colors.black12,
                              ),
                              Positioned(
                                right: 10.0,
                                top: 80,
                                child: SizedBox(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Made by : ',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Text(
                                          'Ginsky',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              color: Colors.grey),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
