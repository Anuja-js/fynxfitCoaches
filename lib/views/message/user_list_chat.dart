import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_bloc.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_event.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/message/message.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
class CoachChatListScreen extends StatefulWidget {
  const CoachChatListScreen({Key? key}) : super(key: key);

  @override
  State<CoachChatListScreen> createState() => _CoachChatListScreenState();
}

class _CoachChatListScreenState extends State<CoachChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Coach Chats",
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else if (state is ChatLoaded) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
              itemCount: state.chatUsers.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade800,
                thickness: 0.5,
                indent: 70.w,
              ),
              itemBuilder: (context, index) {
                final chatUser = state.chatUsers[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  leading: CircleAvatar(
                    radius: 25.r,
                    backgroundImage: NetworkImage(chatUser.userImage),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: chatUser.userName,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chatUser.lastMessageTime != null
                            ? _formatTime(chatUser.lastMessageTime!)
                            : '',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text: chatUser.lastMessage.isNotEmpty
                              ? chatUser.lastMessage
                              : "No messages yet",
                          fontSize: 12.sp,
                          color: Colors.grey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chatUser.isUnread ?? false)
                        Container(
                          margin: EdgeInsets.only(left: 6.w),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoachChatScreen(
                          chatId: chatUser.chatId,username: chatUser.userName,
                          userId: chatUser.userId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final time = TimeOfDay.fromDateTime(date);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }
}
