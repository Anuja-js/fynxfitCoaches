import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_event.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_state.dart';
import 'package:fynxfitcoaches/models/chat_user.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatBloc(this.firestore, this.auth) : super(ChatInitial()) {
    on<LoadChats>(_onLoadChats);
  }

  Future<void> _onLoadChats(LoadChats event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      final coachId = auth.currentUser!.uid;

      final coachDoc = await firestore.collection('coaches').doc(coachId).get();
      final List<dynamic> chatIds = coachDoc.data()?['chatIdLists'] ?? [];

      List<ChatUser> chatUsers = [];

      for (String chatId in chatIds) {
        final userId = chatId.split("_")[0];
        final userDoc = await firestore.collection('users').doc(userId).get();

        String userName = '';
        String userImage = '';
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          userName = userData['name'] ?? '';
          userImage = userData['profileImageUrl'] ?? '';
        }

        final messageQuery = await firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        String lastMessage = '';
        Timestamp? lastMessageTime;
        bool isUnread = false;

        if (messageQuery.docs.isNotEmpty) {
          final msg = messageQuery.docs.first;
          lastMessage = msg['text'] ?? '';
          lastMessageTime = msg['timestamp'];
          List readBy = msg['readBy'] ?? [];

          // If current coachId is not in the readBy list, it's unread
          isUnread = !readBy.contains(coachId);
        }

        chatUsers.add(ChatUser(
          chatId: chatId,
          userId: userId,
          userName: userName,
          userImage: userImage,
          lastMessage: lastMessage,
          lastMessageTime: lastMessageTime!,
          isUnread: isUnread,
        ));
      }

      emit(ChatLoaded(chatUsers));
    } catch (e) {
      print("ChatBloc Error: $e");
      emit(ChatError("Failed to load chats"));
    }
  }
}
