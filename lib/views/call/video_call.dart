import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fynxfitcoaches/bloc/call/call_bloc.dart';
import 'package:fynxfitcoaches/bloc/call/call_event.dart';
import 'package:fynxfitcoaches/bloc/call/call_state.dart';

class CoachCallScreen extends StatefulWidget {
  final String coachId;

  const CoachCallScreen({super.key, required this.coachId});

  @override
  State<CoachCallScreen> createState() => _CoachCallScreenState();
}

class _CoachCallScreenState extends State<CoachCallScreen> {
  Stream<DocumentSnapshot> incomingCallStream(String coachId) {
    return FirebaseFirestore.instance
        .collection('calls')
        .where('receiverId', isEqualTo: coachId)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }
@override
  void initState() {

    super.initState();
  }

  void dispose(){
    context.read<CallBloc>().add(CallEnd());
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Incoming Call")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: incomingCallStream(widget.coachId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final callId = snapshot.data!.id;
            return BlocBuilder<CallBloc, CallState>(
              builder: (context, state) {
                if (state is CallInitial) {
                  return Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<CallBloc>().add(CallInitialize(callId));
                        context.read<CallBloc>().add(CallReceive(callId));
                        FirebaseFirestore.instance
                            .collection('calls')
                            .doc(callId)
                            .update({'status': 'accepted'});
                      },
                      icon: const Icon(Icons.call),
                      label: const Text("Join Call"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  );
                } else if (state is CallActive) {
                  return Stack(
                    children: [
                      RTCVideoView(state.remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,mirror: true,),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                            FirebaseFirestore.instance
                                .collection('calls')
                                .doc(callId)
                                .update({'status': 'ended'});
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is CallLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CallError) {
                  return Center(child: Text("Error: ${state.message}", style: TextStyle(color: Colors.red)));
                } else {
                  return const SizedBox();
                }
              },
            );
          } else {
            return const Center(child: Text("Waiting for call...", style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}
