abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallActive extends CallState {
  final String roomId;
  final String displayName;

  CallActive(this.roomId, this.displayName);
}

class CallError extends CallState {
  final String message;
  CallError(this.message);
}