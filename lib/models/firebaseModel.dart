import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseModel {
  static Future<UserModel?> getUserModelById(String uid) async {
    try {
      DocumentSnapshot docsnap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (docsnap.exists) {
        return UserModel.fromMap(docsnap.data() as Map<String, dynamic>);
      } else {
        print("User document does not exist.");
        return null; // Document does not exist
      }
    } catch (e) {
      print("Error fetching user model: $e");
      return null; // Handle error fetching data
    }
  }
}
