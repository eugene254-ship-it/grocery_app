import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  Stream<QuerySnapshot<Map<String, dynamic>>> getTopPickedStore() {
    try {
      return FirebaseFirestore.instance
          .collection('vendors')
          .where('accVerified', isEqualTo: true)
          .where('isTopPicked', isEqualTo: true)
          //      .orderBy('shopName')
          .snapshots();
    } catch (e) {
      throw Exception('Error getting top picked stores: $e');
    }
  }
}
