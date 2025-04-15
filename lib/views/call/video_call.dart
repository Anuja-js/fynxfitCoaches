import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../bloc/call/call_bloc.dart';
import '../../bloc/call/call_event.dart';
import '../../bloc/call/call_state.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coach Call")),
      body: BlocConsumer<CallBloc, CallState>(
        listener: (context, state) {
          if (state is CallError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CallInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<CallBloc>().add(CallInitialize());
                  context.read<CallBloc>().add(CallReceive());
                },
                child: const Text("Join Call"),
              ),
            );
          } else if (state is CallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CallActive) {
            return Stack(
              children: [
                RTCVideoView(state.remoteRenderer),
                Positioned(
                  right: 20,
                  top: 20,
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: RTCVideoView(state.localRenderer, mirror: true),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: MediaQuery.of(context).size.width * 0.4,
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                    onPressed: () {
                      context.read<CallBloc>().add(CallEnd());
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
