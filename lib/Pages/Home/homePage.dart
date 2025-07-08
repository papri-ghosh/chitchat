// import 'package:chitchat/Pages/auth/authPage.dart';
// import 'package:chitchat/Pages/chatRoom/chatRoomPage.dart';
// import 'package:chitchat/Pages/gemini/uiPage.dart';
// import 'package:chitchat/Pages/profile/profilePage.dart';
// import 'package:chitchat/Pages/searchPage/searchPage.dart';
// import 'package:chitchat/config/image.dart';
// import 'package:chitchat/config/string.dart';
// import 'package:chitchat/models/chatRoomModel.dart';
// import 'package:chitchat/models/firebaseModel.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class HomePage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const HomePage(
//       {super.key, required this.userModel, required this.firebaseUser});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 80,
//           backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//           title: Text(
//             AppString.appName,
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           leading: Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: SvgPicture.asset(
//               AssetsImage.appIocnSVG,
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.popUntil(context, (route) => route.isFirst);
//                 Navigator.pushReplacement(context, MaterialPageRoute(
//                   builder: (context) {
//                     return AuthPage();
//                   },
//                 ));
//               },
//               icon: Icon(Icons.exit_to_app),
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   // My Creation
//                   return ProfilePage(
//                     userModel: widget.userModel,
//                   );
//                 }));
//               },
//               icon: Icon(Icons.more_vert),
//             ),

//             // For Gemini
//             IconButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) {
//                     return UiPage();
//                   }));
//                 },
//                 icon: Icon(Icons.person))
//                 //
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return SearchPage(
//                   userModel: widget.userModel,
//                   firebaseUser: widget.firebaseUser);
//             }));
//           },
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           child: Icon(
//             Icons.search,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//         ),

//         body: SafeArea(
//             child: Container(
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("chatrooms")
//                 .where("participants.${widget.userModel.uid}", isEqualTo: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 if (snapshot.hasData) {
//                   QuerySnapshot chatRoomSnapshot =
//                       snapshot.data as QuerySnapshot;
//                   return ListView.builder(
//                     itemCount: chatRoomSnapshot.docs.length,
//                     itemBuilder: (context, index) {
//                       // Create chatRoomModel
//                       ChatRoom_Model chatRoomModel = ChatRoom_Model.fromMap(
//                           chatRoomSnapshot.docs[index].data()
//                               as Map<String, dynamic>);

//                       Map<String, dynamic>? participants =
//                           chatRoomModel.participants;
//                       List<String> participantsKeys =
//                           participants!.keys.toList();
//                       participantsKeys.remove(widget.userModel.uid);

//                       return FutureBuilder(
//                         future:
//                             FirebaseModel.getUserModelById(participantsKeys[0]),
//                         builder: (context, userData) {
//                           if (userData.connectionState ==
//                               ConnectionState.done) {
//                             if (userData.data != null) {
//                               UserModel targetUser = userData.data as UserModel;

//                               print(
//                                   "last message ${chatRoomModel.lastMessage}");

//                               return Container(
//                                 padding: EdgeInsets.only(top: 20),
//                                 child: ListTile(
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(
//                                       builder: (context) {
//                                         return ChatRoomPage(
//                                             targetUser: targetUser,
//                                             chatroom: chatRoomModel,
//                                             userModel: widget.userModel,
//                                             firebaseUser: widget.firebaseUser);
//                                       },
//                                     ));
//                                   },
//                                   title: Text(
//                                     targetUser.fullname.toString(),
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   subtitle: (chatRoomModel.lastMessage
//                                               .toString() !=
//                                           "")
//                                       ? Text(
//                                           chatRoomModel.lastMessage.toString(),
//                                           style: TextStyle(fontSize: 16),
//                                         )
//                                       : Text("Say hi to your new friend !",
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.blueAccent)),
//                                   leading: CircleAvatar(
//                                     maxRadius: 30,
//                                     backgroundImage: NetworkImage(
//                                         targetUser.pictures.toString()),
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               return Container();
//                             }
//                           } else {
//                             return Container();
//                           }
//                         },
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(snapshot.error.toString()),
//                   );
//                 } else {
//                   return Center(
//                     child: Text("No Chats"),
//                   );
//                 }
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         )));
//   }
// }

//******************************************************************************************** */

import 'package:chitchat/Pages/status/storyPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add GetX for state management
import 'package:chitchat/Pages/auth/authPage.dart';
import 'package:chitchat/Pages/chatRoom/chatRoomPage.dart';
import 'package:chitchat/Pages/gemini/uiPage.dart';
import 'package:chitchat/Pages/profile/profilePage.dart';
import 'package:chitchat/Pages/searchPage/searchPage.dart';
import 'package:chitchat/config/image.dart';
import 'package:chitchat/config/string.dart';
import 'package:chitchat/models/chatRoomModel.dart';
import 'package:chitchat/models/firebaseModel.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Use RxInt to toggle between Chat (0), Gemini (1), and Status (2)
  var selectedTab = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            AppString.appName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              AssetsImage.appIocnSVG,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return AuthPage();
                  },
                ));
              },
              icon: Icon(Icons.exit_to_app),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  // My Creation
                  return ProfilePage(
                    userModel: widget.userModel,
                  );
                }));
              },
              icon: Icon(Icons.more_vert),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchPage(
                        userModel: widget.userModel,
                        firebaseUser: widget.firebaseUser);
                  }));
                },
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onBackground,
                ))
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context) {
        //       return SearchPage(
        //           userModel: widget.userModel,
        //           firebaseUser: widget.firebaseUser);
        //     }));
        //   },
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   child: Icon(
        //     Icons.search,
        //     color: Theme.of(context).colorScheme.onBackground,
        //   ),
        // ),
        // Add bottom navigation for "Chat", "Gemini", "Status"
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: selectedTab.value,
              onTap: (index) {
                selectedTab.value = index;
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      size: 20,
                    ),
                    label: "Chat"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.star,
                      size: 20,
                    ),
                    label: "Gemini"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.update,
                      size: 20,
                    ),
                    label: "Status"),
              ],
            )),
        // Conditional body rendering based on selected tab
        body: Obx(() {
          if (selectedTab.value == 0) {
            // Chat view (existing StreamBuilder)
            return SafeArea(
                child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .where("participants.${widget.userModel.uid}",
                        isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot chatRoomSnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          // Create chatRoomModel
                          ChatRoom_Model chatRoomModel = ChatRoom_Model.fromMap(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          Map<String, dynamic>? participants =
                              chatRoomModel.participants;
                          List<String> participantsKeys =
                              participants!.keys.toList();
                          participantsKeys.remove(widget.userModel.uid);

                          return FutureBuilder(
                            future: FirebaseModel.getUserModelById(
                                participantsKeys[0]),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                if (userData.data != null) {
                                  UserModel targetUser =
                                      userData.data as UserModel;

                                  print(
                                      "last message ${chatRoomModel.lastMessage}");

                                  return Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ChatRoomPage(
                                                targetUser: targetUser,
                                                chatroom: chatRoomModel,
                                                userModel: widget.userModel,
                                                firebaseUser:
                                                    widget.firebaseUser);
                                          },
                                        ));
                                      },
                                      title: Text(
                                        targetUser.fullname.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: (chatRoomModel.lastMessage
                                                  .toString() !=
                                              "")
                                          ? Text(
                                              chatRoomModel.lastMessage
                                                  .toString(),
                                              style: TextStyle(fontSize: 16),
                                            )
                                          : Text("Say hi to your new friend !",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueAccent)),
                                      leading: CircleAvatar(
                                        maxRadius: 30,
                                        backgroundImage: NetworkImage(
                                            targetUser.pictures.toString()),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: Text("No Chats"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ));
          } else if (selectedTab.value == 1) {
            // Gemini view
            return UiPage(); // You can design the Gemini page here.
          } else {
            // Status view
            return StoryPage(); // Placeholder for Status section
          }
        }));
  }
}
