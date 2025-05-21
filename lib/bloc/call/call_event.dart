abstract class CallEvent {}

class CallInitialize extends CallEvent {
  final String callId;
  final String? displayName;

  CallInitialize(this.callId, {this.displayName});
}

class CallEnd extends CallEvent {}