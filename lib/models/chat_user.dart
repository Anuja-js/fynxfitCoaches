import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String chatId;
  final String userId;
  final String userName;
  final String userImage;
  final Timestamp lastMessageTime;
  final bool isUnread;
  final String lastMessage;

  ChatUser({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isUnread,
  });
}
