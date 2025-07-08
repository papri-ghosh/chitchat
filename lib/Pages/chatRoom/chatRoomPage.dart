// ******************************************************* Work Able Code *************************************
/*
import 'package:chitchat/Pages/TargetUser/targetUserProfile.dart';
import 'package:chitchat/Pages/chatRoom/widgets/imageSender.dart';
import 'package:chitchat/config/colors.dart';
import 'package:chitchat/models/chatRoomModel.dart';
import 'package:chitchat/models/messageModel.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoom_Model chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  final DateFormat timeFormat = DateFormat('hh:mm a');
  final ImageSender _imageSender = ImageSender();
  late String userStatus;

  @override
  void initState() {
    super.initState();
    updateUserStatus(
        "Online"); // Set user status to Online when entering the chat room
  }

  @override
  void dispose() {
    updateUserStatus(
        "Offline"); // Set user status to Offline when leaving the chat room
    super.dispose();
  }

  /// Updates the user's status in Firestore.
  void updateUserStatus(String status) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid) // Assuming the user model has the uid
        .update({"status": status});
  }

  /// Sends a text message. If [imageUrl] is provided, it sends an image message.
  void sendMessage({String? imageUrl}) async {
    String msg = messageController.text.trim();

    if (msg.isNotEmpty || imageUrl != null) {
      MessageModel newMessage = MessageModel(
        messageId: Uuid().v1(),
        sender: widget.userModel.uid!,
        createdon: DateTime.now(),
        text: msg.isNotEmpty ? msg : null,
        seen: false,
        imageUrl: imageUrl,
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomId)
          .update({
        "lastmessage": newMessage.text ?? "Image",
        "lastmessgae": newMessage.text ?? "Image",
      });

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      print("Message sent");
      messageController.clear();
    }
  }

  /// Handles image selection and sending using ImageSender.
  void handleImageSend() {
    _imageSender.pickAndSendImage(
      chatRoomId: widget.chatroom.chatRoomId!,
      senderId: widget.userModel.uid!,
      onImageSent: (String? imageUrl) {
        if (imageUrl != null) {
          sendMessage(imageUrl: imageUrl);
        }
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TargetUserProfile(targetUser: widget.targetUser,chatroom: widget.chatroom,firebaseUser: widget.firebaseUser,userModel: widget.targetUser,);
                }));
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    NetworkImage(widget.targetUser.pictures.toString()),
              ),
            ),
            SizedBox(width: 10),
            Text(widget.targetUser.fullname.toString()),
            SizedBox(width: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(
                      widget.targetUser.uid) // Assuming the target user has uid
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    userStatus = snapshot.data!['status'] ?? "Offline";
                    Color statusColor =
                        userStatus == "Online" ? Colors.green : Colors.red;

                    return Text(
                      userStatus,
                      style: TextStyle(color: statusColor, fontSize: 20),
                    );
                  }
                }
                return Text("Offline", style: TextStyle(color: Colors.red));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatRoomId)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>,
                            );

                            return Column(
                              crossAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uid)
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (currentMessage.imageUrl != null) ...[
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Image.network(
                                              currentMessage.imageUrl!),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      child: Image.network(
                                        currentMessage.imageUrl!,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                                if (currentMessage.text != null) ...[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: (currentMessage.sender ==
                                              widget.userModel.uid)
                                          ? donContainerColor
                                          : dContainerColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      currentMessage.text!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                ],
                                Text(
                                  timeFormat.format(currentMessage.createdon!),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blueGrey),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("An Error Occurred"));
                      } else {
                        return Center(child: Text("Say hi to your New Friend"));
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: donContainerColor,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Message",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: donContainerColor,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: handleImageSend,
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                    color: dContainerColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

//******************&&&&&&&&&&&&&&&&&&&&&&&&((((((((((((((((())))))))))))^^^^^^^^^^^))))) */


import 'package:chitchat/Pages/TargetUser/targetUserProfile.dart';
import 'package:chitchat/Pages/chatRoom/widgets/imageSender.dart';
import 'package:chitchat/config/colors.dart';
import 'package:chitchat/models/chatRoomModel.dart';
import 'package:chitchat/models/messageModel.dart';
import 'package:chitchat/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoom_Model chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  final DateFormat timeFormat = DateFormat('hh:mm a');
  final ImageSender _imageSender = ImageSender();
  
  // Store the selected image URL
  String? selectedImageUrl;

  @override
  void initState() {
    super.initState();
    updateUserStatus("Online");
  }

  @override
  void dispose() {
    updateUserStatus("Offline");
    super.dispose();
  }

  void updateUserStatus(String status) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .update({"status": status});
  }

  /// Sends a message with optional imageUrl
  void sendMessage({String? imageUrl}) async {
    String msg = messageController.text.trim();

    if (msg.isNotEmpty || imageUrl != null) {
      MessageModel newMessage = MessageModel(
        messageId: Uuid().v1(),
        sender: widget.userModel.uid!,
        createdon: DateTime.now(),
        text: msg.isNotEmpty ? msg : null,
        seen: false,
        imageUrl: imageUrl,
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomId)
          .update({
        "lastmessage": newMessage.text ?? "Image",
        "lastmessgae": newMessage.text ?? "Image",
      });

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      print("Message sent");
      messageController.clear();

      setState(() {
        selectedImageUrl = null; // Clear image preview after sending
      });
    }
  }

  /// Handles image selection
  void handleImageSelection() {
    _imageSender.pickAndSendImage(
      chatRoomId: widget.chatroom.chatRoomId!,
      senderId: widget.userModel.uid!,
      onImageSent: (String? imageUrl) {
        setState(() {
          selectedImageUrl = imageUrl; // Store image for preview
        });
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TargetUserProfile(
                        targetUser: widget.targetUser,
                        chatroom: widget.chatroom,
                        firebaseUser: widget.firebaseUser,
                        userModel: widget.targetUser,
                      );
                    },
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(widget.targetUser.pictures.toString()),
              ),
            ),
            SizedBox(width: 10),
            Text(widget.targetUser.fullname.toString()),
            SizedBox(width: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.targetUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  String userStatus = snapshot.data!['status'] ?? "Offline";
                  Color statusColor = userStatus == "Online"
                      ? Colors.green
                      : Colors.red;

                  return Text(
                    userStatus,
                    style: TextStyle(color: statusColor, fontSize: 20),
                  );
                }
                return Text("Offline", style: TextStyle(color: Colors.red));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatRoomId)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data() as Map<String, dynamic>);

                          return Column(
                            crossAxisAlignment:
                                currentMessage.sender == widget.userModel.uid
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              if (currentMessage.imageUrl != null) ...[
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Image.network(currentMessage.imageUrl!),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    height: 150,
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        currentMessage.imageUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                              if (currentMessage.text != null) ...[
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: currentMessage.sender == widget.userModel.uid
                                        ? donContainerColor
                                        : dContainerColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    currentMessage.text!,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 1),
                              ],
                              Text(
                                timeFormat.format(currentMessage.createdon!),
                                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("An Error Occurred"));
                    } else {
                      return Center(child: Text("Say hi to your New Friend"));
                    }
                  },
                ),
              ),
            ),
            if (selectedImageUrl != null) ...[
              Container(
                margin: EdgeInsets.all(8),
                height: 150,
                width: 150,
                child: Image.network(selectedImageUrl!),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: donContainerColor,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Message",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: donContainerColor,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: handleImageSelection,
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(imageUrl: selectedImageUrl);
                    },
                    icon: const Icon(Icons.send),
                    color: dContainerColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


