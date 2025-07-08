// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

// typedef OnImageSentCallback = void Function(String? imageUrl);

// class ImageSender {
//   final ImagePicker _picker = ImagePicker();

//   /// Picks an image from the gallery and uploads it to Firebase Storage.
//   /// After uploading, it calls the [onImageSent] callback with the image URL.
//   Future<void> pickAndSendImage({
//     required String chatRoomId,
//     required String senderId,
//     required OnImageSentCallback onImageSent,
//     required BuildContext context,
//   }) async {
//     try {
//       final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

//       if (pickedImage != null) {
//         File imageFile = File(pickedImage.path);
//         String imageId = Uuid().v1();

//         // Show a loading indicator while uploading
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => Center(child: CircularProgressIndicator()),
//         );

//         // Upload image to Firebase Storage
//         UploadTask uploadTask = FirebaseStorage.instance
//             .ref("chatrooms/$chatRoomId/images/$imageId")
//             .putFile(imageFile);

//         TaskSnapshot snapshot = await uploadTask;
//         String imageUrl = await snapshot.ref.getDownloadURL();

//         // Close the loading indicator
//         Navigator.of(context).pop();

//         // Callback with the image URL
//         onImageSent(imageUrl);
//       }
//     } catch (e) {
//       // Close any open dialogs
//       Navigator.of(context).pop();
//       // Handle errors appropriately in your app
//       print("Error picking/sending image: $e");
//       // Optionally, show a snackbar or dialog to inform the user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send image. Please try again.")),
//       );
//     }
//   }
// }



//******************* BOTH ARE CORRECT */


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import the image package
import 'package:uuid/uuid.dart';

typedef OnImageSentCallback = void Function(String? imageUrl);

class ImageSender {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery, compresses it, and uploads it to Firebase Storage.
  /// After uploading, it calls the [onImageSent] callback with the image URL.
  Future<void> pickAndSendImage({
    required String chatRoomId,
    required String senderId,
    required OnImageSentCallback onImageSent,
    required BuildContext context,
  }) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        File imageFile = File(pickedImage.path);
        String imageId = Uuid().v1();

        // Compress the image
        File compressedImage = await compressImage(imageFile);

        // Show a loading indicator while uploading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        // Upload the compressed image to Firebase Storage
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("chatrooms/$chatRoomId/images/$imageId")
            .putFile(compressedImage);

        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Close the loading indicator
        Navigator.of(context).pop();

        // Callback with the image URL
        onImageSent(imageUrl);
      }
    } catch (e) {
      // Close any open dialogs
      Navigator.of(context).pop();
      // Handle errors appropriately
      print("Error picking/sending image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send image. Please try again.")),
      );
    }
  }

  /// Compresses the image to reduce its file size.
  Future<File> compressImage(File imageFile) async {
    final img.Image? decodedImage = img.decodeImage(imageFile.readAsBytesSync());

    if (decodedImage == null) throw Exception("Could not decode image");

    // Resize the image to a maximum width of 800 while keeping aspect ratio
    final img.Image resizedImage = img.copyResize(
      decodedImage,
      width: 800,
    );

    // Save the compressed image as a new file
    final compressedFile = File('${imageFile.path}_compressed.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 70)); // Adjust quality (1-100)

    return compressedFile;
  }
}
