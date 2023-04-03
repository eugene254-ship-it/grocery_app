import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserServices {
  String collection = 'users';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //create new user

  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await firestore.collection(collection).doc(id).set(values);
  }

  //Update User Data
  Future<void> updateUserData(String id, Map<String, dynamic> values) async {
    await firestore.collection(collection).doc(id).update(values);
  }

  //Get User By ID
  Future<UserModel?> getUserById(String id) async {
    return await firestore.collection(collection).doc(id).get().then((doc) {
      if (doc.data() == null) {
        return null;
      }
      return UserModel.fromSnapshot(doc);
    });
  }
}
