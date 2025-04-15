import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/controlers/singnal_controler.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final SignalingController signaling;

  CallBloc(this.signaling) : super(CallInitial()) {
    on<CallInitialize>((event, emit) async {
      emit(CallLoading());
      try {
        await signaling.initialize();
        emit(CallActive(signaling.localRenderer, signaling.remoteRenderer));
      } catch (e) {
        emit(CallError("Init failed: $e"));
      }
    });

    on<CallReceive>((event, emit) async {
      emit(CallLoading());
      try {
        await signaling.receiveCall();
        emit(CallActive(signaling.localRenderer, signaling.remoteRenderer));
      } catch (e) {
        emit(CallError("Receiving call failed: $e"));
      }
    });

    on<CallEnd>((event, emit) async {
      await signaling.disposeResources();
      emit(CallInitial());
    });
  }
}
