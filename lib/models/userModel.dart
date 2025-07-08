// class UserModel {
//   String? uid;
//   String? fullname;
//   String? email;
//   String? pictures;

//   UserModel({this.uid, this.fullname, this.email, this.pictures});

// // Serialization -> Get object from Map
//   UserModel.fromMap(Map<String, dynamic> map) {
//     uid = map["uid"];
//     fullname = map["fullname"];
//     email = map["email"];
//     pictures = map["pictures"];
//   }

// // DeSerialization -> Get Map from Object
//   Map<String, dynamic> toMap() {
//     return {
//       "uid": uid,
//       "fullname": fullname,
//       "email": email,
//       "pictures": pictures
//     };
//   }
// }

//******************************************************************************************************* */

// class UserModel {
//   String? uid;
//   String? fullname;
//   String? email;
//   String? pictures;
//   String? phone;
//   String? about;

//   UserModel(
//       {this.uid,
//       this.fullname,
//       this.email,
//       this.pictures,
//       this.phone,
//       this.about});

//   // Serialization: Convert user model to map
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'fullname': fullname,
//       'email': email,
//       'pictures': pictures,
//       'phone': phone,
//       'about': about,
//     };
//   }

//   // Deserialization: Create user model from map
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'],
//       fullname: map['fullname'],
//       email: map['email'],
//       pictures: map['pictures'],
//       phone: map['phone'],
//       about: map['about'],
//     );
//   }
// }

//******************************************************************************************************* */
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? pictures;
  String? phone;
  String? about;
  String? status; // Online, Offline, etc.
  Timestamp? lastSeen; // To track last seen time

  UserModel({
    this.uid,
    this.fullname,
    this.email,
    this.pictures,
    this.phone,
    this.about,
    this.status,
    this.lastSeen,
  });

  // Serialization: Convert user model to map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'pictures': pictures,
      'phone': phone,
      'about': about,
      'status': status, 
      'lastSeen': lastSeen,
    };
  }

  // Deserialization: Create user model from map with safe casting
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullname: map['fullname'] ?? 'Unknown',
      email: map['email'] ?? '',
      pictures: map['pictures'] ?? '',
      phone: map['phone'] ?? '',
      about: map['about'] ?? '',
      status: map['status'] ?? 'Offline', // Default to 'Offline'
      lastSeen: map['lastSeen'] as Timestamp?, // Safe casting for Timestamp
    );
  }
}
