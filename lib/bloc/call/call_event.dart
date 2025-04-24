abstract class CallEvent {}

class CallInitialize extends CallEvent {
final String callId;
CallInitialize(this.callId);
}

class CallReceive extends CallEvent {

  final String callId;
  CallReceive(this.callId);
}


class CallEnd extends CallEvent {}
