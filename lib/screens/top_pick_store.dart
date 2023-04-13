// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/screens/welcome_screen.dart';
import 'package:grocery_app/services/store_services.dart';

import '../services/user_services.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key? key}) : super(key: key);

  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices storeServices = StoreServices();
  UserServices userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      if (mounted) {
        userServices.getUserById(user!.uid).then((result) {
          if (result.data() != null) {
            final data = result.data() as Map<String, dynamic>;
            setState(() {
              userLatitude = data['latitude'];
              userLongitude = data['longitude'];
            });
          } else {
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          }
        });
      }
    } else {
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }
  }

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
        userLatitude, userLongitude, location.latitude, location.longitude);
    var distanceInKm = distance / 1000; //this will show in kilometer
    return distanceInKm.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData) return const CircularProgressIndicator();
          List shopDistance = [];
          for (int i = 0; i < snapShot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                userLatitude,
                userLongitude,
                snapShot.data!.docs[i]['location'].latitude,
                snapShot.data!.docs[i]['location'].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (shopDistance[0] > 10) {
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 30,
                        child: Image.asset('assets/images/like.gif')),
                    const Text(
                      'Top Picked Stores For You',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        snapShot.data!.docs.map((DocumentSnapshot document) {
                      if (double.parse(getDistance(document['location'])) <=
                          10) {
                        //shows stores in 10Km
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Card(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        document['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: Text(
                                    document['shopName'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${getDistance(document['location'])}Km',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        //if no stores
                        return Container();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
