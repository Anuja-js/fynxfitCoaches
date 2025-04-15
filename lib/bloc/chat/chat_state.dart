import 'package:fynxfitcoaches/models/chat_user.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatUser> chatUsers;
  ChatLoaded(this.chatUsers);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
