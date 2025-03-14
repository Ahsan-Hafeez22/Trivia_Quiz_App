import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> updateUserData(
      String uid, String firstName, String lastName, String phoneNumber) async {
    await userCollection.doc(uid).update({
      'name': '$firstName $lastName',
      'phone_number': phoneNumber,
    });
  }
}
