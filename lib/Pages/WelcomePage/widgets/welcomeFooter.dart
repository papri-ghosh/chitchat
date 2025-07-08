import 'package:chitchat/Pages/Home/homePage.dart';
import 'package:chitchat/config/string.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WelcomeFooterbutton extends StatelessWidget {
  const WelcomeFooterbutton({super.key});

  Future<UserModel?> getUserModelFromFirestore(User firebaseUser) async {
    // Example Firestore query to get user model, adjust to your needs
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    if (docSnap.exists) {
      return UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      onSubmit: () async {
        User? firebaseUser = FirebaseAuth.instance.currentUser;

        if (firebaseUser != null) {
           print("Current User UID: ${firebaseUser.uid}");
          // Fetch the user model from Firestore
          UserModel? userModel = await getUserModelFromFirestore(firebaseUser);

          if (userModel != null) {
            // Navigate to Home Page with the user model and firebase user
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage(userModel: userModel, firebaseUser: firebaseUser);
            }));
          } else {
            // Handle case where userModel couldn't be fetched
            Get.snackbar("Error", "User model not found.");
          }
        } else {
          // If user is not logged in, navigate to Login Page
          Get.offAllNamed("/authPage");
        }

        print("Success");
      },
      text: WelcomePageString.slideToStart,
      textStyle: Theme.of(context).textTheme.labelLarge,
      submittedIcon: Icon(Icons.check),
      sliderButtonIcon: const Icon(
        Icons.power,
        weight: 25,
      ),
      innerColor: Theme.of(context).colorScheme.primary,
      outerColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}



