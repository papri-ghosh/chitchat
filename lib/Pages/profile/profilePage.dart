/*import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({
    super.key,
    required this.userModel,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userModel.fullname ?? '';
    aboutController.text = widget.userModel.about ?? ''; // Initialize here
    phoneController.text = widget.userModel.phone ?? ''; // Initialize here
  }

  void checkValue() {
    String about = aboutController.text.trim();
    String phone = phoneController.text.trim();

    // Check if fields are empty
    if (about.isEmpty || phone.isEmpty) {
      Get.snackbar("Empty Field", "Please fill all the fields.");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    String about = aboutController.text.trim();
    String phone = phoneController.text.trim();

    // Update the UserModel with the new values
    widget.userModel.about = about;
    widget.userModel.phone = phone;

    try {
      // Save the updated user data to Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .update(widget.userModel.toMap());

      // Update the UI with new values
      setState(() {
        aboutController.text = about; // Reflect changes in the UI
        phoneController.text = phone; // Reflect changes in the UI
      });

      // Optionally, show a success message
      Get.snackbar("Success", "Profile updated successfully.");
    } catch (e) {
      // Handle potential errors
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.userModel.pictures != null &&
                              widget.userModel.pictures!.isNotEmpty
                          ? Image.network(widget.userModel.pictures!,
                              fit: BoxFit.cover)
                          : const Icon(Icons.image,
                              size: 100), // Placeholder if no image
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: aboutController,
                  decoration: const InputDecoration(
                    labelText: "About",
                    prefixIcon: Icon(Icons.info),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller:
                      TextEditingController(text: widget.userModel.email ?? ''),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone No.",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    checkValue();
                  },
                  child: PrimaryButton(
                    btnName: "Save",
                    icon: Icons.save,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({
    super.key,
    required this.userModel,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userModel.fullname ?? '';
    aboutController.text = widget.userModel.about ?? '';
    phoneController.text = widget.userModel.phone ?? '';
  }

  void checkValue() {
    String fullname = nameController.text.trim();
    String about = aboutController.text.trim();
    String phone = phoneController.text.trim();

    // Check if fields are empty
    if (fullname.isEmpty || about.isEmpty || phone.isEmpty) {
      Get.snackbar("Empty Field", "Please fill all the fields.");
    } else {
      uploadData(fullname);
    }
  }

  void uploadData(String fullname) async {
    String about = aboutController.text.trim();
    String phone = phoneController.text.trim();

    // Update the UserModel with the new values
    widget.userModel.fullname = fullname; // Update fullname
    widget.userModel.about = about;
    widget.userModel.phone = phone;

    try {
      // Save the updated user data to Firestore ************************************************(IMP)
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userModel.uid)
          .update(widget.userModel.toMap());

      // Update the UI with new values
      setState(() {
        nameController.text = fullname; // Reflect changes in the UI
        aboutController.text = about;
        phoneController.text = phone;
      });

      // Optionally, show a success message
      Get.snackbar("Success", "Profile updated successfully.");
    } catch (e) {
      // Handle potential errors
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.userModel.pictures != null &&
                              widget.userModel.pictures!.isNotEmpty
                          ? Image.network(widget.userModel.pictures!,
                              fit: BoxFit.cover)
                          : const Icon(Icons.image,
                              size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: aboutController,
                  decoration: const InputDecoration(
                    labelText: "About",
                    prefixIcon: Icon(Icons.info),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller:
                      TextEditingController(text: widget.userModel.email ?? ''),
                  enabled: false,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone No.",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    checkValue();
                  },
                  child: PrimaryButton(
                    btnName: "Save",
                    icon: Icons.save,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
