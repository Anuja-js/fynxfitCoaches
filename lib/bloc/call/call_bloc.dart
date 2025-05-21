// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../controlers/singnal_controler.dart';
// import 'call_event.dart';
// import 'call_state.dart';
//
// class CallBloc extends Bloc<CallEvent, CallState> {
//   final JitsiCallController jitsi;
//
//   CallBloc(this.jitsi) : super(CallInitial()) {
//     on<CallInitialize>((event, emit) async {
//       emit(CallLoading());
//       try {
//         await jitsi.joinMeeting(
//           room: event.callId,
//           displayName: event.displayName ?? "Anonymous",
//         );
//         emit(CallActive(event.callId, event.displayName ?? "Anonymous"));
//       } catch (e) {
//         emit(CallError("Failed to join: $e"));
//       }
//     });
//
//     on<CallEnd>((event, emit) async {
//       jitsi.hangUp();
//       emit(CallInitial());
//     });
//   }
// }