// class MessageModel {
//   String? messageId;
//   String? sender;
//   String? text;
//   bool? seen;
//   DateTime? createdon;

//   MessageModel(
//       {this.messageId, this.sender, this.text, this.seen, this.createdon});

//   MessageModel.fromMap(Map<String, dynamic> map) {
//     messageId = map["messageId"];
//     sender = map["sender"];
//     text = map["text"];
//     seen = map["seen"];
//     createdon = map["createdon"].toDate();
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "messageId": messageId,
//       "sender": sender,
//       "text": text,
//       "seen": seen,
//       "createdon": createdon
//     };
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String messageId;
  String sender;
  DateTime? createdon;
  String? text;
  bool seen;
  String? imageUrl; // Add this field

  MessageModel({
    required this.messageId,
    required this.sender,
    this.createdon,
    this.text,
    required this.seen,
    this.imageUrl, // Initialize this field
  });

  // Convert MessageModel to Map
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'sender': sender,
      'createdon': createdon,
      'text': text,
      'seen': seen,
      'imageUrl': imageUrl, // Include this field
    };
  }

  // Create MessageModel from Map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      sender: map['sender'] ?? '',
      createdon: (map['createdon'] as Timestamp?)?.toDate(),
      text: map['text'],
      seen: map['seen'] ?? false,
      imageUrl: map['imageUrl'], // Initialize this field
    );
  }
}
