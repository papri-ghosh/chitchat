// import 'package:chitchat/Pages/chatRoom/chatRoomPage.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';

// class ContactSearch extends StatefulWidget {
//   const ContactSearch({super.key});

//   @override
//   State<ContactSearch> createState() => _ContactSearchState();
// }

// class _ContactSearchState extends State<ContactSearch> {
//   Map<String, dynamic>? userMap;
//   final TextEditingController _search = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void onSearch() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     String searchTerm =
//         _search.text.toLowerCase(); // Convert search term to lowercase

//     await _firestore.collection('users').get().then((value) {
//       setState(() {
//         // Find the first matching user
//         var matchingUser = value.docs.map((doc) => doc.data()).firstWhere(
//               (user) => user['fullname'].toLowerCase() == searchTerm,
//               orElse: () => {}, // Return an empty map if no match is found
//             );

//         // Check if a user was found
//         if (matchingUser.isNotEmpty) {
//           userMap = matchingUser; // Use the matching user
//         } else {
//           userMap = null; // No user found
//         }

//         print(userMap);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Theme.of(context).colorScheme.primaryContainer,
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _search,
//                   textInputAction: TextInputAction.done,
//                   onSubmitted: (value) {
//                     print(value);
//                     onSearch();
//                     // Call onSearch when the user submits the input
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Search Contact",
//                     prefixIcon: InkWell(
//                       child: Icon(Icons.search),
//                       onTap: () {
//                         onSearch();
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20), // Add some spacing
//           if (userMap != null) // Display user info if found
//             Container(
//               padding: EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: dPrimaryColor //donContainerColor,
//                   ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.account_box, size: 24), // Leading icon
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           "${userMap!['fullname']}",
//                           style: TextStyle(
//                               fontSize: 19, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       InkWell(
//                         child: Icon(Icons.message, size: 24),
//                         onTap: () {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return ChatRoomPage();
                           
//                           }));
//                         },
//                       ), // Trailing icon
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           else if (userMap == null &&
//               _search.text.isNotEmpty) // Show message if no user found
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("No user found", style: TextStyle(color: Colors.red)),
//             ),

//           SizedBox(
//             height: 15,
//           )
//         ],
//       ),
//     );
//   }
// }




//********************************************************* */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> firebaseData = [];
  bool noItemFound = false;
  bool isLoading = false;
  TextEditingController searchedItem = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    searchedItem.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void searchFromFirebase(String input) async {
    // Cancel any existing debounce timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (input.isEmpty) {
        setState(() {
          firebaseData = [];
          noItemFound = false;
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = true;
        noItemFound = false;
      });

      final lowerCaseInput = input.toLowerCase().trim();

      try {
        // Perform a Firestore query to fetch matching documents
        final result = await FirebaseFirestore.instance
            .collection('users')
            .where('fullname_lowercase', isGreaterThanOrEqualTo: lowerCaseInput)
            .where('fullname_lowercase', isLessThanOrEqualTo: lowerCaseInput + '\uf8ff')
            .get();

        setState(() {
          firebaseData = result.docs.map((e) => e.data() as Map<String, dynamic>).toList();
          noItemFound = firebaseData.isEmpty;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          firebaseData = [];
          noItemFound = true;
          isLoading = false;
        });
        print("Error fetching data: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: TextField(
            controller: searchedItem,
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 19,
                fontStyle: FontStyle.italic,
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade500, width: 3),
              ),
            ),
            onChanged: searchFromFirebase,
          ),
        ),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else if (noItemFound)
          Center(
            child: Text(
              "User not found",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: firebaseData.length,
              itemBuilder: (context, index) {
                final user = firebaseData[index];
                final picture = user['pictures'];

                return Container(
                  color: const Color.fromARGB(255, 225, 232, 254),
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          picture != null ? NetworkImage(picture) : null,
                      child: picture == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    title: Text(
                      user["fullname"],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    subtitle: Text(
                      user["email"],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
