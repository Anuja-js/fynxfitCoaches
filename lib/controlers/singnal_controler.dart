import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignalingController {
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  final _firestore = FirebaseFirestore.instance;
  late String _callId;

  Future<void> initialize({required String callId}) async {
    _callId = callId;

    // Initialize renderers
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    // Get user media (camera and mic)
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      },
    });

    localRenderer.srcObject = _localStream;

    // Create peer connection
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    });

    // Add local tracks
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onTrack = (event) {
      print('Remote track received');
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };


    // Debug ICE connection state
    _peerConnection!.onIceConnectionState = (state) {
      print("ICE Connection State: $state");
    };

    // Send ICE candidates to Firestore
    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        _firestore
            .collection('calls')
            .doc(_callId)
            .collection('candidates')
            .add({
          'candidates': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };
  }

  Future<void> receiveCall(String callId) async {
    _callId = callId;
    print("Receiving call with ID: $callId");

    final doc = await _firestore.collection('calls').doc(callId).get();
    final data = doc.data();

    if (data == null || data['offer'] == null) {
      throw Exception('Call data or offer not found');
    }

    final offer = RTCSessionDescription(
      data['offer']['sdp'],
      data['offer']['type'],
    );

    await _peerConnection!.setRemoteDescription(offer);

    // Create and send answer
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    await _firestore.collection('calls').doc(callId).update({
      'answer': {
        'type': answer.type,
        'sdp': answer.sdp,
      }
    });
    await FirebaseFirestore.instance
        .collection('calls')
        .doc(callId)
        .update({'hasJoined': true});


    // Listen for ICE candidates from caller
    _firestore
        .collection("calls")
        .doc(callId)
        .collection("candidates")
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          if (data != null && data['candidates'] != null) {

            final candidate = RTCIceCandidate(
              data['candidates'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            );
            _peerConnection!.addCandidate(candidate);
            print("Remote ICE candidate added: ${data['candidates']}");
          }
        }
      }
    });
  }

  Future<void> disposeResources() async {
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    await _localStream?.dispose();
    await _peerConnection?.close();
    _peerConnection = null;
  }
}
