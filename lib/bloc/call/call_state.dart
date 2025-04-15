import 'package:flutter_webrtc/flutter_webrtc.dart';

abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallActive extends CallState {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  CallActive(this.localRenderer, this.remoteRenderer);
}

class CallError extends CallState {
  final String message;
  CallError(this.message);
}
