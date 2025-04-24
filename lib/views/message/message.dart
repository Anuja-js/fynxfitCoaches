import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_bloc.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_event.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/call/video_call.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import 'package:intl/intl.dart';
import '../../widgets/customs/custom_text.dart';

class CoachChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;
  final String username;

  const CoachChatScreen({required this.chatId, required this.userId,required this.username, Key? key}) : super(key: key);

  @override
  State<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends State<CoachChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    markMessagesAsRead(widget.chatId);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatBloc>().add(LoadChats());
      });

  }

  void markMessagesAsRead(String chatId) async {
    final messagesRef = FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages");

    try {
      final snapshot = await messagesRef.get(); // Get all or limit if needed

      for (var doc in snapshot.docs) {
        List readBy = doc['readBy'] ?? [];

        if (!readBy.contains(currentUserId)) {
          await doc.reference.update({
            "readBy": FieldValue.arrayUnion([currentUserId])
          });
        }
      }
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  void sendMessage() async {
    final String text = messageController.text.trim();
    if (text.isEmpty) return;

    final message = {
      "text": text,
      "senderId": currentUserId,
      "timestamp": FieldValue.serverTimestamp(),
      "receiverId": widget.userId,
      "chatId": widget.chatId,
      "readBy": [currentUserId]
    };

    final messageRef = FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatId)
        .collection("messages")
        .doc();

    await messageRef.set(message);

    messageController.clear();

    Future.delayed(Duration(milliseconds: 300), () {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
// Helper functions
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        title: CustomText(text:widget.username,fontSize: 15.sp,fontWeight: FontWeight.bold,),
        actions: [
          IconButton(
            icon: Icon(Icons.call,color:  AppThemes.darkTheme.appBarTheme.foregroundColor,),
            tooltip: 'Audio Call',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio Call Pressed')),
              );
            },
          ),
          IconButton(
            icon:  Icon(Icons.videocam,color:AppThemes.darkTheme.appBarTheme.foregroundColor,),
            tooltip: 'Video Call',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CoachCallScreen(coachId: FirebaseAuth.instance.currentUser!.uid)

                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video Call Pressed')),
              );
            },
          ),
        ],
        leading: IconButton(onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainPage()
            ),
          ).then((_) {
            context.read<ChatBloc>().add(LoadChats());
          });


      }, icon: Icon(Icons.arrow_back,color: AppThemes.darkTheme.appBarTheme.foregroundColor,)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return const Center(child: Text("No messages yet"));

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUserId;
                    final timestamp = msg['timestamp'] as Timestamp?;
                    final time = timestamp != null ? timestamp.toDate() : DateTime.now();
                    final formattedTime = DateFormat('hh:mm a').format(time);
                    final formattedDate = DateFormat('yyyy-MM-dd').format(time);


                    // Date Divider Logic
                    bool showDate = false;
                    if (index == messages.length - 1) {
                      showDate = true;
                    } else {
                      final nextMsg = messages[index + 1];
                      final nextTimestamp = nextMsg['timestamp'] as Timestamp?;
                      final nextDate = nextTimestamp != null
                          ? DateFormat('yyyy-MM-dd').format(nextTimestamp.toDate())
                          : '';
                      if (nextDate != formattedDate) {
                        showDate = true;
                      }
                    }

                    return Column(
                      children: [
                        if (showDate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isToday(time)
                                      ? 'Today'
                                      : isYesterday(time)
                                      ? 'Yesterday'
                                      : DateFormat('MMM dd, yyyy').format(time),
                                  style: const TextStyle(color: Colors.white),
                                ),

                              ),
                            ),
                          ),
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.purple : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  msg["text"],
                                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMe ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );

              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: (){
                    sendMessage();
                    // sendPushNotification(
                    //     "New Message", messageController.text.trim());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> sendPushNotification(String title, String body) async {
  //   // Replace with your actual JSON file path
  //   final serviceAccountJson = 'assets/service-account.json';
  //   final user =
  //   await FirebaseFirestore.instance.collection("users").doc(widget.userId).get();
  //   final serviceAccount = ServiceAccountCredentials.fromJson({
  //     "type": "service_account",
  //     "project_id": "fynxfit",
  //     "private_key_id": "f8fc20233e74fc91768fb67ed56f1f395b65d9de",
  //     "private_key":
  //     "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDMGLrr1hCqIRCN\n8Dxn743qUrT2rXnNg9RMpCfexHALtCqZb22JKKRJItqYwSrhVskqkiuuWzNX4moN\ngFuiAjCzqObSkY7bqHYRlyMsPuDFpExVJYYXZU5+pHBqv42XjhZolchtCy3Y1Cs+\nDbPlYxeq+fYXB8W3sVKwXhUS145QAPPraIs+pMx2GQTCH4+DhRSlP1jEm9yOWtkI\n32Qh/i/gICbHKZKwwrByYWsIkzd1WdqZ/ezLFFVkPQGvNJjuKR8QhGr00P1pFbAO\nRkCgu3RuZVhLVPZwWIDKbxNA7iE6aR59Wb8OS2SCZR/8FnnvSMhdq36LUdMVeK5u\nvflMTngpAgMBAAECggEAD/ZBLC+eNwgF+OvYdZJ9KV3VjFNN6t5MDMBr49a+IpQx\nHrXhva/hhVzF9ttopJ36dqte4jB8x/tLqwmmYPnF4E8t2jsLDq/SqBaHaC70ulBa\nrfAU2CCSroHizt5zTu6MXxqTxb9xkvso9J3yu1ZwI+2PqwZvFqo2GtgI0uPr2+LL\nb4Weu0c7Nd+SIeMrLKsWN5npsKdUFVA5l6XLEmRefgGrpeTJsXJ09+eBwtriHoYI\nsjnsKrgQY6qQTNt7a6XzSZ0Q5ulqlKzfAu1ySIjXFATI6gR7fVhLNu+lD8zwTcrs\nVnesIytXK+1J4eWsT796NrH4ipua6CUMxIgVeiwelwKBgQDmcNI4hws0siJh1q8p\nwn/Hi8SvlbvJT+PpMzrhlTfM73WqBiPMcMSZ8PK0OczgzicEWg97Yz56rYtauHGJ\ngqpHU6Mna692Y9lL9NmQM/QXKa3zwa3aZgulTdk1WAQTmth84zVQJh9uzdL05zqL\nfJTFhbXQk9F8Q6jIbpXU+QnzywKBgQDiu+OnAbjigUVgZKs0yiw9dPlvZFEkUY29\n+C+sq56o8jTH8exY7j9yae8XyRLbij8805eERzvdRj36ZzoeUodcneum4Uubizgp\nRcduXy/r306iNNL2Shevv0VUFep4+K7ROz5mbIfYEuWJy6KOwTq34/ZqvC7GqXUm\nei7iW7qNWwKBgCTHhQX4p9U1ST+MYFCt9m8G49GSeHJdCedCgfdXNZzD62fDqxsK\nNJbNWi9huk13GcscBLSQ1nwGDuPf5F8qN7tCohu8mDixHxF8du0JHcBEqrrpArKE\n7v7nOe/FqIDoif0E1pGARCwPNchYz4NL0wLjoG016o2Gzv2OiOOBDBGZAoGAVCKC\nnJNgBvUPSHCyszkeZ4PDl5kzHvYAUfEJx9o7WtfdzCAyouFtu8ghh8L+c2b+hlTC\nEbzZMwgAsa2ifGQFhNG5A0jw5Hwpz+7rzUIXJ0DLDhfp/KiL15RzZntncZJeVJfW\nVO2LDxwb/yEIZk6/ukMmSn8gIGn7ZdbLFQYS2KcCgYAhefDHaW52p3xKI0crfFfE\ntbKIPJnfi0uyfc+RduQm02Cuoc72K5ajXee3q6jTtN4nyZqo6KK6FvQBxrbNeKeG\nNhETqYVmowDXypmLIl8UTfNv9lI5aoqWHWN9C/hNo5JPyne0sbbUwFP9JtCmW90q\n7yIYh3FV7ZuiF6RUh/Q0Ow==\n-----END PRIVATE KEY-----\n",
  //     "client_email": "fcm-sender@fynxfit.iam.gserviceaccount.com",
  //     "client_id": "110566486742074336971",
  //     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //     "token_uri": "https://oauth2.googleapis.com/token",
  //     "auth_provider_x509_cert_url":
  //     "https://www.googleapis.com/oauth2/v1/certs",
  //     "client_x509_cert_url":
  //     "https://www.googleapis.com/robot/v1/metadata/x509/fcm-sender%40fynxfit.iam.gserviceaccount.com",
  //     "universe_domain": "googleapis.com"
  //   });
  //
  //   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  //
  //   final client = await clientViaServiceAccount(serviceAccount, scopes);
  //
  //   final projectId = 'fynxfit'; // Replace with your actual project ID
  //
  //   final url = Uri.parse(
  //       'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
  //
  //   final message = {
  //     "message": {
  //       "token":user["fcmtocken"],
  //       "notification": {
  //         "title": title,
  //         "body": body,
  //       },
  //       "android": {
  //         "priority": "HIGH",
  //       },
  //       "apns": {
  //         "headers": {"apns-priority": "10"},
  //         "payload": {
  //           "aps": {"sound": "default"}
  //         }
  //       }
  //     }
  //   };
  //
  //   final response = await client.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(message),
  //   );
  //
  //   print("Status Code: ${response.statusCode}");
  //   print("Response: ${response.body}");
  //
  //   client.close();
  // }
}
