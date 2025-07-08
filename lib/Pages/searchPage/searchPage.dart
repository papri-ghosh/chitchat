// import 'package:chitchat/Pages/chatRoom/chatRoomPage.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class SearchPage extends StatefulWidget {
//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   List firebaseData = [];
//   var noItemFound = false;
//   TextEditingController searchedItem = TextEditingController();

//   void searchFromFirebase(String input) async {
//     final result = await FirebaseFirestore.instance.collection('users').get();
//     final lowerCaseInput = input.toLowerCase().trim();

//     setState(() {
//       if (result.docs.isEmpty) {
//         firebaseData = [];
//         noItemFound = true;
//       } else {
//         firebaseData = result.docs.map((e) => e.data()).where((data) {
//           final fullname = (data['fullname'] as String).toLowerCase();
//           return fullname.contains(lowerCaseInput);
//         }).toList();
//         noItemFound = firebaseData.isEmpty;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         toolbarHeight: 80,
//         backgroundColor: dContainerColor,
//         title: Text(
//           "Search",
//           style: Theme.of(context).textTheme.headlineLarge,
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
//             child: TextField(
//               controller: searchedItem,
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 fillColor: donContainerColor,
//                 filled: true,
//                 hintStyle: Theme.of(context)
//                     .textTheme
//                     .bodyLarge!
//                     .copyWith(color: Colors.white),
//               ),
//             ),
//           ),
//           SizedBox(height: 40),
//           ElevatedButton(
//             onPressed: () {
//               searchFromFirebase(searchedItem.text);
//             },
//             style: ElevatedButton.styleFrom(
//               primary: dContainerColor, // Background color
//               onPrimary: dPrimaryColor, // Text color
//             ),
//             child: Text("Search",
//                 style: Theme.of(context).textTheme.headlineSmall),
//           ),
//           SizedBox(height: 30),
//           noItemFound
//               ? Text(
//                   "No User Found",
//                   style: TextStyle(color: Colors.red, fontSize: 22),
//                 )
//               : Expanded(
//                   child: ListView.builder(
//                     itemCount: firebaseData.length,
//                     itemBuilder: (context, index) {
//                       final user = firebaseData[index];
//                       return ListTile(
//                         onTap: () {
//                           Navigator.pop(context);
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return ChatRoomPage();
//                           }));
//                         },
//                         leading: CircleAvatar(
//                           maxRadius: 40,
//                           backgroundImage: NetworkImage(user["pictures"] ??
//                               ''), // Ensure you have this field in Firestore
//                         ),
//                         title: Text(user["fullname"]),
//                         subtitle: Text(user["email"]),
//                         trailing: Icon(Icons.keyboard_arrow_right),
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
// import 'package:chitchat/main.dart';
// import 'package:chitchat/models/chatRoomModel.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:chitchat/config/colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// class SearchPage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const SearchPage(
//       {super.key, required this.userModel, required this.firebaseUser});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   List firebaseData = [];
//   var noItemFound = false;
//   TextEditingController searchedItem = TextEditingController();

//   void searchFromFirebase(String input) async {
//     // Fetch all documents from the 'users' collection
//     final result = await FirebaseFirestore.instance.collection('users').get();

//     // Convert the input to lowercase for case-insensitive comparison
//     final lowerCaseInput = input.toLowerCase().trim();

//     setState(() {
//       if (result.docs.isEmpty) {
//         firebaseData = [];
//         noItemFound = true;
//       } else {
//         // Filter documents locally based on the lowercase input
//         firebaseData = result.docs
//             .map((e) => e
//                 .data()) //.map((e) => e.data()):This converts each document snapshot (e) to its data (e.data()).
//             .where((data) {
//           final fullname = (data['fullname'] as String).toLowerCase();
//           final email = (data['email'] as String);

//           print(fullname);

//           return email != widget.firebaseUser.email &&
//               fullname.contains(
//                   lowerCaseInput); // contains -> lowerCaseInput is present or not in fullname
//         }).toList(); // Convert QuerySnapshot<Map<String, dynamic>> to List

//         noItemFound = firebaseData.isEmpty;
//       }
//     });
//   }

//   Future<ChatRoom_Model?> getChatRoom(UserModel targetUser) async {
//     ChatRoom_Model? chatRoom;

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection("chatrooms")
//         .where("participants.${widget.userModel.uid}", isEqualTo: true)
//         .where("participants.${targetUser.uid}", isEqualTo: true)
//         .get();

//     if (snapshot.docs.length > 0) {
//       // ChatRoom already Exist
//       var docsData = snapshot.docs[0].data();
//       ChatRoom_Model existingChatRoom =
//           ChatRoom_Model.fromMap(docsData as Map<String, dynamic>);

//       chatRoom = existingChatRoom;

//       print("ChatRoom already Exist");
//     } else {
//       // Create a New ChatRoom
//       ChatRoom_Model newChatRoom =
//           ChatRoom_Model(chatRoomId: uuid.v1(), lastMessage: "", participants: {
//         widget.userModel.uid.toString(): true,
//         targetUser.uid.toString(): true,
//       });

//       // Store date in Firebase
//       await FirebaseFirestore.instance
//           .collection("chatrooms")
//           .doc(newChatRoom.chatRoomId)
//           .set(newChatRoom.toMap());

//       chatRoom = newChatRoom;

//       print("New ChatRoom Created");
//     }
//     return chatRoom;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           toolbarHeight: 70,
//           backgroundColor: dContainerColor,
//           title: Text(
//             "Search",
//             style: Theme.of(context).textTheme.headlineLarge,
//           ),
//         ),
//         body: SafeArea(
//             child: Column(
//           children: [
//             Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
//                 child: TextField(
//                   controller: searchedItem,
//                   decoration: InputDecoration(
//                     hintText: "Search...",
//                     hintStyle: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 19,
//                       //fontWeight: FontWeight.w400,
//                       fontStyle: FontStyle.italic,
//                     ),
//                     fillColor: donContainerColor,
//                     filled: true,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         borderSide: BorderSide.none),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(color: dPrimaryColor, width: 2),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide:
//                           BorderSide(color: Colors.grey.shade500, width: 3),
//                     ),
//                   ),
//                   onChanged:
//                     (input) {
//                       searchFromFirebase(input);
//                     }
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {

//                   },
//                   child: const PrimaryButton(
//                     btnName: "Search",
//                     icon: Icons.lock_open_outlined,
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//                 child: noItemFound
//                     ? Center(
//                         child: Text(
//                         "User not found",
//                         style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red),
//                       ))
//                     : ListView.builder(
//                         itemCount: firebaseData.length,
//                         itemBuilder: (context, Index) {
//                           //For accessing image
//                           final user = firebaseData[Index];
//                           final picture = user['pictures'];

//                           // targetuser -> is the object of UserModel class
//                           UserModel targetuser = UserModel.fromMap(user);

//                           return Container(
//                             color: const Color.fromARGB(255, 225, 232, 254),
//                             margin: const EdgeInsets.symmetric(vertical: 5),
//                             child: ListTile(
//                               onTap: () async {
//                                 ChatRoom_Model? chatRoomModel =
//                                     await getChatRoom(targetuser);

//                                 if (chatRoomModel != null) {
//                                   Navigator.pop(context);
//                                   // Navigator.push(context,
//                                   //     MaterialPageRoute(builder: ((context) {
//                                   //   return ChatRoomPage(
//                                   //     targetUser: targetuser,
//                                   //     userModel: widget.userModel,
//                                   //     firebaseUser: widget.firebaseUser,
//                                   //     chatRoom: chatRoomModel,
//                                   //   );
//                                   // })));
//                                 }
//                               },
//                               leading: CircleAvatar(
//                                 backgroundImage: picture != null
//                                     ? NetworkImage(picture)
//                                     : null,
//                                 child:
//                                     picture == null ? Icon(Icons.person) : null,
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 10),
//                               title: Text(
//                                 firebaseData[Index]["fullname"],
//                                 style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87),
//                               ),
//                               subtitle: Text(
//                                 firebaseData[Index]["email"],
//                                 style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black54),
//                               ),
//                               trailing: Icon(Icons.keyboard_arrow_right),
//                             ),
//                           );
//                         }))
//           ],
//         )));
//   }
// }

import 'package:chitchat/Pages/auth/widgets/primaryButton.dart';
import 'package:chitchat/Pages/chatRoom/chatRoomPage.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/chatRoomModel.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chitchat/config/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List firebaseData = [];
  var noItemFound = false;
  TextEditingController searchedItem = TextEditingController();

  void searchFromFirebase(String input) async {
    // Fetch all documents from the 'users' collection
    final result = await FirebaseFirestore.instance.collection('users').get();

    // Convert the input to lowercase for case-insensitive comparison
    final lowerCaseInput = input.toLowerCase().trim();

    setState(() {
      if (result.docs.isEmpty) {
        firebaseData = [];
        noItemFound = true;
      } else {
        // Filter documents locally based on the lowercase input
        firebaseData = result.docs
            .map((e) => e.data()) // Convert each document snapshot to its data
            .where((data) {
          final fullname = (data['fullname'] as String).toLowerCase();
          final email = (data['email'] as String);

          print(fullname);

          return email != widget.firebaseUser.email &&
              fullname.contains(lowerCaseInput);
        }).toList(); // Convert QuerySnapshot<Map<String, dynamic>> to List

        noItemFound = firebaseData.isEmpty;
      }
    });
  }

  Future<ChatRoom_Model?> getChatRoom(UserModel targetUser) async {
    ChatRoom_Model? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      // ChatRoom already Exist
      var docsData = snapshot.docs[0].data();
      ChatRoom_Model existingChatRoom =
          ChatRoom_Model.fromMap(docsData as Map<String, dynamic>);

      chatRoom = existingChatRoom;

      print("ChatRoom already Exist");
    } else {
      // Create a New ChatRoom
      ChatRoom_Model newChatRoom =
          ChatRoom_Model(chatRoomId: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });

      // Store data in Firebase
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());

      chatRoom = newChatRoom;

      print("New ChatRoom Created");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70,
          backgroundColor: dContainerColor,
          title: Text(
            "Search",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: TextField(
                  controller: searchedItem,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontStyle: FontStyle.italic,
                    ),
                    fillColor: donContainerColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: dPrimaryColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.grey.shade500, width: 3),
                    ),
                  ),
                  onChanged: (input) {
                    // Optional: You can still call the search on text change
                    // searchFromFirebase(input);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Call the search function with the input from the TextField
                    searchFromFirebase(searchedItem.text);
                  },
                  child: const PrimaryButton(
                    btnName: "Search",
                    icon: Icons.search,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Expanded(
                child: noItemFound
                    ? Center(
                        child: Text(
                        "User not found",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))
                    : ListView.builder(
                        itemCount: firebaseData.length,
                        itemBuilder: (context, Index) {
                          // For accessing image
                          final user = firebaseData[Index];
                          final picture = user['pictures'];

                          // targetuser -> is the object of UserModel class
                          UserModel targetuser = UserModel.fromMap(user);

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: dContainerColor,
                            ),
                            child: ListTile(
                              onTap: () async {
                                ChatRoom_Model? chatRoomModel =
                                    await getChatRoom(targetuser);

                                if (chatRoomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatRoomPage(
                                        targetUser: targetuser,
                                        chatroom: chatRoomModel,
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser);
                                  }));
                                }
                              },
                              leading: CircleAvatar(
                                maxRadius: 30,
                                backgroundImage: picture != null
                                    ? NetworkImage(picture)
                                    : null,
                                child:
                                    picture == null ? Icon(Icons.person) : null,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              title: Text(
                                firebaseData[Index]["fullname"],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                firebaseData[Index]["email"],
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            ),
                          );
                        }))
          ],
        )));
  }
}
