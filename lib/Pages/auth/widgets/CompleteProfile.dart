// import 'dart:io';
// import 'package:chitchat/Pages/Home/homePage.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class CompleteProfile extends StatefulWidget {
//   final UserModel? userModel;
//   final User? firebaseUser; //firebaseAuth
//   const CompleteProfile(
//       {super.key, required this.userModel, required this.firebaseUser});

//   @override
//   State<CompleteProfile> createState() => _CompleteProfileState();
// }

// class _CompleteProfileState extends State<CompleteProfile> {
//   File? imageFile; // Make imageFile nullable
//   TextEditingController fullnameController = TextEditingController();

//   void selectImage(ImageSource source) async {
//     XFile? pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       cropImage(pickedFile);
//     }
//   }

//   void cropImage(XFile file) async {
//     CroppedFile? croppedImage = await ImageCropper().cropImage(
//         sourcePath: file.path,
//         aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//         compressQuality: 20);
//     if (croppedImage != null) {
//       setState(() {
//         imageFile =
//             File(croppedImage.path); // Assign the cropped image to imageFile
//       });
//     }
//   }

//   void showPhotoOption() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Upload Profile Picture"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   onTap: () {
//                     selectImage(ImageSource.gallery);
//                     Navigator.pop(
//                         context); // Close the dialog after picking image
//                   },
//                   leading: Icon(Icons.photo_album),
//                   title: Text("Select From Gallery"),
//                 ),
//                 ListTile(
//                   onTap: () {
//                     selectImage(ImageSource.camera);
//                     Navigator.pop(
//                         context); // Close the dialog after taking photo
//                   },
//                   leading: Icon(Icons.camera_alt),
//                   title: Text("Take a Photo"),
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   void checkValues() {
//     String fullname = fullnameController.text.trim();
//     if (imageFile == null || fullname == "") {
//       print("Fill all the fields");
//     } else {
//       uploadData();
//     }
//   }

//   void uploadData() async {
//   try {
//     // Upload file to Firebase Storage
//     UploadTask uploadTask = FirebaseStorage.instance
//         .ref("profilepictures")
//         .child(widget.userModel!.uid.toString())
//         .putFile(imageFile!);
//     TaskSnapshot snapshot = await uploadTask;

//     // Get the download URL after successful upload
//     String imageUrl = await snapshot.ref.getDownloadURL();
//     String fullname = fullnameController.text.trim();

//     // Update the user model with the new data
//     widget.userModel!.fullname = fullname;
//     widget.userModel!.pictures = imageUrl;

//     // Save user data to Firestore
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(widget.userModel!.uid)
//         .set(widget.userModel!.toMap())
//         .then((value) {
//       print("Data Uploaded");

//       // Show success Snackbar
//       Get.snackbar(
//         "Success",
//         "Profile data uploaded successfully!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: dContainerColor,
//         colorText: Colors.white,
//       );

//       // You can also navigate to another page if needed
//        Get.to(() => HomePage());
//     });
//   } catch (e) {
//     print("Error uploading data: $e");

//     // Show error Snackbar
//     Get.snackbar(
//       "Error",
//       "Failed to upload profile data. Please try again.",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Complete Profile"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Theme.of(context).colorScheme.primaryContainer,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 30),
//                   CupertinoButton(
//                     onPressed: () {
//                       showPhotoOption();
//                     },
//                     child: CircleAvatar(
//                       radius: 80,
//                       backgroundColor: donContainerColor,
//                       backgroundImage:
//                           imageFile != null ? FileImage(imageFile!) : null,
//                       child: imageFile == null
//                           ? const Icon(
//                               Icons.person,
//                               size: 60,
//                               color: Colors.white,
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   TextField(
//                     controller: fullnameController,
//                     decoration: InputDecoration(
//                       hintText: "Full Name",
//                       labelStyle: const TextStyle(color: Colors.white),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 100),
//                   ElevatedButton(
//                     onPressed: () {
//                       checkValues();
//                       // Placeholder for submit function
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 50,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       "Submit",
//                       style: TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:chitchat/config/colors.dart';
import 'package:get/get.dart';
import 'package:chitchat/Pages/Home/homePage.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const Profile(
      {super.key, required this.userModel, required this.firebaseuser});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imageFile;
  TextEditingController fullnameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      cropImage(pickedImage);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Upload Profile Picture"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: Icon(Icons.photo_album),
                title: Text("Select from Gallery"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Photo"),
              ),
            ],
          ),
        );
      },
    );
  }

  void checkValue() {
    String fullName = fullnameController.text.trim();

    if (fullName.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
    } else {
      uploadData();
    }
  }

  // Upload image in database
  void uploadData() async {
    try {
      // Upload the image
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("profilepicture")
          .child(widget.userModel.uid.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Log image URL for debugging
      print("Image URL: $imageUrl");

      // Update userModel
      String fullName = fullnameController.text.trim();
      widget.userModel.fullname = fullName;
      widget.userModel.pictures = imageUrl;

      // Upload data to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .set(widget.userModel.toMap());

      print("Data updated successfully");

      //ScaffoldMessenger is like a tool that helps you show temporary messages or
      //notifications at the bottom of your screen. These messages are called SnackBars.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Updated Successfully')),
      );

      // Check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
                userModel: widget.userModel, firebaseUser: widget.firebaseuser),
          ),
        );
      }
    } catch (e) {
      print("Error updating data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Complete Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  CupertinoButton(
                    onPressed: () {
                      showPhotoOption();
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: donContainerColor,
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile!) : null,
                      child: imageFile == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: fullnameController,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      checkValue();
                      // Placeholder for submit function
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // body: SafeArea(
      //   child: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 30),
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           Colors.orange, // Starting color
      //           Colors.yellow, // Ending color
      //         ],
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //     ),
      //     child: ListView(
      //       children: [
      //         SizedBox(height: 30),
      //         CupertinoButton(
      //           onPressed: showPhotoOption,
      //           child: CircleAvatar(
      //             radius: 70,
      //             backgroundColor: Colors.purpleAccent,
      //             backgroundImage:
      //                 imageFile != null ? FileImage(imageFile!) : null,
      //             child: imageFile == null
      //                 ? Icon(
      //                     Icons.person,
      //                     size: 50,
      //                     color: Colors.white,
      //                   )
      //                 : null,
      //           ),
      //         ),
      //         SizedBox(height: 40),
      //         TextField(
      //           controller: fullnameController,
      //           decoration: InputDecoration(
      //             labelText: "Full Name",
      //             labelStyle: TextStyle(color: Colors.white),
      //           ),
      //         ),
      //         SizedBox(height: 40),
      //         CupertinoButton(
      //           child: Text(
      //             "Submit",
      //             style: TextStyle(
      //                 fontSize: 20, color: Colors.white, letterSpacing: 1),
      //           ),
      //           color: Colors.purple[100],
      //           onPressed: checkValue,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
