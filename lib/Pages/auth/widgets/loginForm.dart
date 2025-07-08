// import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginForm extends StatelessWidget {
//   const LoginForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//     TextEditingController passwordController = TextEditingController();

//     // Function to handle login logic
//     void login(String email, String password) async {
//       UserCredential? credential;
//       try {
//         credential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(email: email, password: password);

//         // Successfully logged in
//         if (credential != null) {
//           String uid = credential.user!.uid;
//           DocumentSnapshot userdata = await FirebaseFirestore.instance
//               .collection("users")
//               .doc(uid)
//               .get();
//           UserModel userModel =
//               UserModel.fromMap(userdata.data() as Map<String, dynamic>);

//           print("Login Successful");

//           Get.snackbar(
//             "Success",
//             "Login Successful",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: dContainerColor,
//             colorText: Colors.white,
//           );

//           // Navigate to the next screen if needed
//         }
//       } on FirebaseAuthException catch (ex) {
//         String errorMessage;
//         switch (ex.code) {
//           case 'user-not-found':
//             errorMessage = "No user found for that email.";
//             break;
//           case 'wrong-password':
//             errorMessage = "Incorrect password.";
//             break;
//           case 'invalid-email':
//             errorMessage = "The email address is not valid.";
//             break;
//           default:
//             errorMessage = "An unexpected error occurred.";
//         }

//         Get.snackbar(
//           "Login Failed",
//           errorMessage,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       } catch (e) {
//         Get.snackbar(
//           "Error",
//           "An unexpected error occurred.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       }
//     }

//     // Function to validate input fields
//     void checknewValue() {
//       String email = emailController.text.trim();
//       String password = passwordController.text.trim();
//       if (email.isEmpty || password.isEmpty) {
//         Get.snackbar(
//           "Error",
//           "Please enter all fields",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//         );
//       } else {
//         login(email, password);
//       }
//     }

//     return Column(
//       children: [
//         const SizedBox(height: 40),
//         TextField(
//           controller: emailController,
//           decoration: const InputDecoration(
//             hintText: "Email",
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
//         const SizedBox(height: 60),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 checknewValue();
//                 Get.offNamed("/homePage");
//               },
//               child: const PrimaryButton(
//                 btnName: "LOGIN",
//                 icon: Icons.lock_open_outlined,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/model/usermodel.dart';
// import 'package:firebase/page/homePage.dart';
// import 'package:firebase/page/signup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordcontroller = TextEditingController();

//   void checknewValue() {
//     String email = emailcontroller.text.trim();
//     String password = passwordcontroller.text.trim();
//     if (email == "" || password == "") {
//       print("Enter all field");
//     } else {
//       // print("Sign Up Successfully");
//       login(email, password);
//     }
//   }

//   void login(String email, String password) async {
//     UserCredential? credential;
//     try {
//       credential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//     } on FirebaseAuthException catch (ex) {
//       print(ex.code.toString());
//     }

//     if (credential != null) {
//       String uid = credential.user!.uid;
//       DocumentSnapshot userdata =
//           await FirebaseFirestore.instance.collection("users").doc(uid).get();
//       UserModel userModel =
//           UserModel.fromMap(userdata.data() as Map<String, dynamic>);

//       print("Login Successful");

//       // Display message in bottom of page
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login Successfull")));

//       Navigator.pushReplacement(context, MaterialPageRoute(
//         builder: (context) {
//           return HomePage(
//               userModel: userModel, firebaseUser: credential!.user!);
//         },
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.purple.withOpacity(0.8),
//               Colors.blue.withOpacity(0.8),
//               Colors.lightBlueAccent.withOpacity(0.8),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             ),
//             ),
//         child: SafeArea(
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image(
//                     image: AssetImage("assets/1.png"),
//                     height: 350,
//                   ),
//                   TextField(
//                     controller: emailcontroller,
//                     decoration: InputDecoration(labelText: "Email Address"),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   TextField(
//                     controller: passwordcontroller,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   CupertinoButton(
//                       child: Text(
//                         "Log In",
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       color: Colors.lightBlueAccent,
//                       onPressed: () {
//                         checknewValue();
//                       })
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),

//       bottomNavigationBar: Container(

//         child: Container(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Don't have any account?",
//                 style: TextStyle(fontSize: 20, color: Colors.blue),
//               ),
//               CupertinoButton(
//                   child: Text(
//                     "SignUp",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   onPressed: () {
//                     Navigator.push(context,
//                         (MaterialPageRoute(builder: (context) => SignUp())));
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
import 'package:chitchat/Pages/Home/homePage.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void checknewValue() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    if (email == "" || password == "") {
      print("Enter all field");
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userdata =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userdata.data() as Map<String, dynamic>);

      print("Login Successful");

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Successful")));

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomePage(
              userModel: userModel, firebaseUser: credential!.user!);
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        const SizedBox(height: 40),
        TextField(
          controller: emailcontroller,
          decoration: const InputDecoration(
            hintText: "Email",
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

         const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                checknewValue();
               
              },
              child: const PrimaryButton(
                btnName: "LOGIN",
                icon: Icons.lock_open_outlined,
              ),
            ),
          ],
        ),



      ]
      
      
      
      
       
    );
  }
}
