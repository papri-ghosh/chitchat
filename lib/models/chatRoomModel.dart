class ChatRoom_Model {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;


  ChatRoom_Model({this.chatRoomId, this.participants, this.lastMessage});

  ChatRoom_Model.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["chatRoomId"];
    participants = map["participants"];
    //lastMessage = map["lastmessage"];
    lastMessage = map["lastmessgae"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomId": chatRoomId,
      "participants": participants,
      "lastmessgae": lastMessage,
    };
  }
}
