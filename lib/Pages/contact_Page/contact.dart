import 'package:chitchat/Pages/contact_Page/widgets/contactSearch.dart';
import 'package:chitchat/Pages/contact_Page/widgets/newContactTile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  RxBool isSearchEnable = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text("Select Contact"),
        actions: [
          Obx(() => IconButton(
              onPressed: () {
                isSearchEnable.value = !isSearchEnable.value;
                print("search");
              },
              icon:
                  isSearchEnable.value ? Icon(Icons.close) : Icon(Icons.search)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            
            Obx(() => isSearchEnable.value ? SearchPage():SizedBox() ),
            SizedBox(
              height: 20,
            ),
            NewContactTile(
                btnName: "New Contact",
                icon: Icons.person_add,
                ontap: () {
                  print("Tapped");
                }),
            SizedBox(
              height: 20,
            ),
            NewContactTile(
                btnName: "New Group",
                icon: Icons.group,
                ontap: () {
                  print("Tapped");
                })
          ],
        ),
      ),
    );
  }
}

