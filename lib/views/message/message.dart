import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_bloc.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_event.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/call/video_call.dart';
import 'package:fynxfitcoaches/views/message/user_list_chat.dart';
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
                  builder: (_) => CallScreen()
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
              builder: (_) => CoachChatListScreen(
              ),
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
                                  DateFormat('MMM dd, yyyy').format(time),
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
                              color: isMe ? Colors.green : Colors.grey.shade300,
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
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
