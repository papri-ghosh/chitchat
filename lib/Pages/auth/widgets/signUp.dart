// import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   // Controllers for input fields
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController cpasswordController = TextEditingController();

//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to validate input fields
//   void checkValues() {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String cpassword = cpasswordController.text.trim();

//     if (email.isEmpty || password.isEmpty || cpassword.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please enter data in all fields",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } else if (password != cpassword) {
//       Get.snackbar(
//         "Error",
//         "Passwords do not match",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } else {
//       signup(email, password);
//     }
//   }

//   // Function to handle sign-up logic
//   void signup(String email, String password) async {
//     try {
//       // Show loading indicator
//       Get.dialog(
//         const Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );

//       // Create user with Firebase Auth
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Get user UID
//       String uid = credential.user!.uid;

//       // Create a new user model
//       UserModel newUser = UserModel(
//         uid: uid,
//         email: email,
//         fullname: "",
//         pictures: "",
//       );

//       // Save user data to Firestore
//       await _firestore.collection("users").doc(uid).set(newUser.toMap());

//       // Dismiss loading indicator
//       Get.back();

//       // Show success message
//       // Get.snackbar(
//       //   "Success",
//       //   "New user created",
//       //   snackPosition: SnackPosition.BOTTOM,
//       //   backgroundColor: dContainerColor,
//       //   colorText: Colors.white,
//       // );

//       // Navigate to CompleteProfile page
//       // Get.to(() => const CompleteProfile());
//     } on FirebaseAuthException catch (ex) {
//       // Dismiss loading indicator
//       Get.back();

//       String errorMessage;
//       switch (ex.code) {
//         case 'email-already-in-use':
//           errorMessage = "Email is already in use.";

//           break;
//         case 'invalid-email':
//           errorMessage = "Invalid email address.";
//           break;
//         case 'weak-password':
//           errorMessage = "Password is too weak.";

//           break;
//         default:
//           errorMessage = "An unexpected error occurred.";
//       }

//       // Show error message
//       Get.snackbar(
//         "Sign Up Failed",
//         errorMessage,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       // Dismiss loading indicator
//       Get.back();

//       // Show generic error message
//       Get.snackbar(
//         "Error",
//         "An unexpected error occurred.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose controllers to free resources
//     emailController.dispose();
//     passwordController.dispose();
//     cpasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 40),
//         TextField(
//           controller: emailController,
//           decoration: const InputDecoration(
//             hintText: "Email ID",
//             prefixIcon: Icon(Icons.alternate_email_rounded),
//           ),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             hintText: "Password",
//             prefixIcon: Icon(Icons.password_outlined),
//           ),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: cpasswordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             hintText: "Confirm Password",
//             prefixIcon: Icon(Icons.lock_outline),
//           ),
//         ),
//         const SizedBox(height: 60),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 checkValues();
//                 //Get.offNamed("/completeProfile");
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) {
//                 //         return CompleteProfile(userModel: newUser, firebaseUser: firebaseUser)
//                 //       },
//                 //     ));
//               },
//               child: const PrimaryButton(
//                 btnName: "SIGNUP",
//                 icon: Icons.lock_open_outlined,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// import 'package:chitchat/Pages/auth/widgets/CompleteProfile.dart';
// import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   // Controllers for input fields
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController cpasswordController = TextEditingController();

//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to validate input fields
//   void checkValues() {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//     String cpassword = cpasswordController.text.trim();

//     if (email.isEmpty || password.isEmpty || cpassword.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please enter data in all fields",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } else if (password != cpassword) {
//       Get.snackbar(
//         "Error",
//         "Passwords do not match",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } else {
//       signup(email, password);
//     }
//   }

//   // Function to handle sign-up logic
//   void signup(String email, String password) async {
//     try {
//       // Show loading indicator
//       Get.dialog(
//         const Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );

//       // Create user with Firebase Auth
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Get user UID
//       String uid = credential.user!.uid;

//       // Create a new user model
//       UserModel newUser = UserModel(
//         uid: uid,
//         email: email,
//         fullname: "",
//         pictures: "",
//       );

//       // Save user data to Firestore
//       await _firestore.collection("users").doc(uid).set(newUser.toMap());

//       // Dismiss loading indicator
//       Get.back();

//       // Navigate to CompleteProfile page
//       Get.to(() => Profile(userModel: newUser, firebaseUser: credential.user));

//     } on FirebaseAuthException catch (ex) {
//       // Dismiss loading indicator
//       Get.back();

//       String errorMessage;
//       switch (ex.code) {
//         case 'email-already-in-use':
//           errorMessage = "Email is already in use.";
//           break;
//         case 'invalid-email':
//           errorMessage = "Invalid email address.";
//           break;
//         case 'weak-password':
//           errorMessage = "Password is too weak.";
//           break;
//         default:
//           errorMessage = "An unexpected error occurred.";
//       }

//       // Show error message
//       Get.snackbar(
//         "Sign Up Failed",
//         errorMessage,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       // Dismiss loading indicator
//       Get.back();

//       // Show generic error message
//       Get.snackbar(
//         "Error",
//         "An unexpected error occurred.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // Dispose controllers to free resources
//     emailController.dispose();
//     passwordController.dispose();
//     cpasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 40),
//         TextField(
//           controller: emailController,
//           decoration: const InputDecoration(
//             hintText: "Email ID",
//             prefixIcon: Icon(Icons.alternate_email_rounded),
//           ),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: passwordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             hintText: "Password",
//             prefixIcon: Icon(Icons.password_outlined),
//           ),
//         ),
//         const SizedBox(height: 30),
//         TextField(
//           controller: cpasswordController,
//           obscureText: true,
//           decoration: const InputDecoration(
//             hintText: "Confirm Password",
//             prefixIcon: Icon(Icons.lock_outline),
//           ),
//         ),
//         const SizedBox(height: 60),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 checkValues();
//               },
//               child: const PrimaryButton(
//                 btnName: "SIGNUP",
//                 icon: Icons.lock_open_outlined,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
// import 'package:chitchat/config/colors.dart';
import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
import 'package:get/get.dart';
import 'package:chitchat/Pages/auth/widgets/CompleteProfile.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();

  void checkValue() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String cpassword = cpasswordcontroller.text.trim();

    if (email.isEmpty || password.isEmpty || cpassword.isEmpty) {
      print("Enter data in all fields");
    } else if (password != cpassword) {
      print("Passwords do not match");
    } else {
      signup(email, password);
    }
  }

  void signup(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newuser =
          UserModel(uid: uid, email: email, fullname: "", pictures: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value) => print("New user created"));

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("New user created")));
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return Profile(userModel: newuser, firebaseuser: credential!.user!);
      })));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: emailcontroller,
          decoration: const InputDecoration(
            hintText: "Email ID",
            prefixIcon: Icon(Icons.alternate_email_rounded),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: passwordcontroller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(Icons.password_outlined),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: cpasswordcontroller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "Confirm Password",
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                checkValue();
              },
              child: const PrimaryButton(
                btnName: "SIGNUP",
                icon: Icons.lock_open_outlined,
              ),
            ),
          ],
        ),
      ],
     
    );
  }
}
