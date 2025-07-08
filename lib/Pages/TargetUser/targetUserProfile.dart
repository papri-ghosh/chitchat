// import 'package:chitchat/Pages/TargetUser/button/phone_call.dart';
// import 'package:chitchat/Pages/TargetUser/button/video_call.dart';
// import 'package:chitchat/models/userModel.dart';
// import 'package:flutter/material.dart';

// class TargetUserProfile extends StatefulWidget {
//   final UserModel targetUser;

//   const TargetUserProfile({super.key, required this.targetUser});

//   @override
//   State<TargetUserProfile> createState() => _TargetUserProfileState();
// }

// class _TargetUserProfileState extends State<TargetUserProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           // title: Text("Profile"),
//           ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 170,
//                           height: 170,
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.background,
//                             borderRadius: BorderRadius.circular(100),
//                             image: DecorationImage(
//                               image: NetworkImage(
//                                 widget.targetUser.pictures.toString(),
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         Text(widget.targetUser.fullname ?? "Unknown User",
//                             style: Theme.of(context).textTheme.headlineMedium),
//                         SizedBox(height: 20),
//                         Text(widget.targetUser.email ?? "user@gmail.com",
//                             style: Theme.of(context).textTheme.headlineSmall),
//                         SizedBox(height: 30),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.video_call,
//                                     color: Color(0xffFF9900),
//                                     size: 40,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(context,
//                                         MaterialPageRoute(builder: (context) {
//                                       return VideoCall();
//                                     }));
//                                   },
//                                 ),
//                                 Text(
//                                   "Video",
//                                   style: TextStyle(
//                                       color: Color(0xffFF9900), fontSize: 18),
//                                 )
//                               ],
//                             ),
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.phone,
//                                     color: Color(0xff039C00),
//                                     size: 40,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         (MaterialPageRoute(builder: (context) {
//                                           return Phone_Call();
//                                         })));
//                                   },
//                                 ),
//                                 Text(
//                                   "Call",
//                                   style: TextStyle(
//                                       color: Color(0xff039C00), fontSize: 18),
//                                 )
//                               ],
//                             ),
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.message,
//                                     color: Color(0xff0057FF),
//                                     size: 40,
//                                   ),
//                                   onPressed: () {
//                                     // Add your message logic here
//                                   },
//                                 ),
//                                 Text(
//                                   "Message",
//                                   style: TextStyle(
//                                       color: Color(0xff0057FF), fontSize: 18),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:chitchat/Pages/chatRoom/chatRoomPage.dart';
import 'package:chitchat/models/chatRoomModel.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class TargetUserProfile extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoom_Model chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const TargetUserProfile({
    super.key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<TargetUserProfile> createState() => _TargetUserProfileState();
}

class _TargetUserProfileState extends State<TargetUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 85,
                    backgroundImage:
                        NetworkImage(widget.targetUser.pictures.toString()),
                    backgroundColor:
                        Theme.of(context).colorScheme.background,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.targetUser.fullname ?? "Unknown",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.targetUser.email ?? "No Email",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 20),
                  Text(
                    widget.targetUser.phone ?? "No pnone",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // _buildActionColumn(
                      //   icon: Icons.video_call,
                      //   label: "Video",
                      //   color: const Color(0xffFF9900),
                      //   onTap: () {
                      //     Navigator.push(context,
                      //                    MaterialPageRoute(builder: (context) {
                      //                 return VideoCall();
                      //               }));
                      //   },
                      // ),

                      _buildActionColumn(
                        icon: Icons.phone,
                        label: "Call",
                        color: const Color(0xff039C00),
                        onTap: () {
                         FlutterPhoneDirectCaller.callNumber(widget.targetUser.phone ?? "No pnone");
                        },
                      ),
                      _buildActionColumn(
                        icon: Icons.message,
                        label: "Message",
                        color: const Color(0xff0057FF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoomPage(
                                targetUser: widget.targetUser,
                                chatroom: widget.chatroom,
                                userModel: widget.userModel,
                                firebaseUser: widget.firebaseUser,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionColumn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(color: color, fontSize: 18)),
      ],
    );
  }
}


