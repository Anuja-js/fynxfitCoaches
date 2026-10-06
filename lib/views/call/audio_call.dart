import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'firestore_service.dart';
import 'signaling.dart';

class CoachAudioCallScreen extends StatefulWidget {
  final String userId;
  const CoachAudioCallScreen({super.key, required this.userId});

  @override
  State<CoachAudioCallScreen> createState() => CoachAudioCallScreenState();
}

class CoachAudioCallScreenState extends State<CoachAudioCallScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late String roomId;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  final _roomIdController = TextEditingController();
  Signaling? signaling;
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    startCall(user!.uid.toString()+widget.userId, false);
  }

  @override
  void dispose() {
    signaling?.leaveCall();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  Future<void> startCall(String roomId, bool isCaller) async
  {
    setState(() => _status = isCaller ? 'Creating room...' : 'Joining room...');
    try {
      signaling = Signaling(
        roomId: roomId,
        localRenderer: _localRenderer,
        remoteRenderer: _remoteRenderer,
      );
      await signaling!.init(isCaller: isCaller);
      setState(() => _status = 'In call');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> leaveCall() async {
    final endTime = DateTime.now();
    final duration = signaling?.startTime != null
        ? endTime.difference(signaling!.startTime!).inSeconds
        : 0;
    await signaling?.leaveCall();

    setState(() => _status = 'Call ended');
    await FirestoreService().addCallHistory(
      userId: widget.userId,
      callData: {
        'timestamp': Timestamp.now(),
        'callWith': widget.userId,
        'type':  'audio',
        'duration': duration,
      },
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Call'),
        backgroundColor: Colors.teal[800],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                // backgroundImage: NetworkImage(widget.),
              ),
              const SizedBox(height: 20),
              Text(
                'Calling ${widget.userId}...',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Status: $_status',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'joinAudio',
                    backgroundColor: Colors.teal[700],
                    onPressed: () => startCall(widget.userId + user!.uid.toString(), false),
                    child: const Icon(Icons.call),
                  ),
                  FloatingActionButton(
                    heroTag: 'leaveAudio',
                    backgroundColor: Colors.red,
                    onPressed: leaveCall,
                    child: const Icon(Icons.call_end),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
