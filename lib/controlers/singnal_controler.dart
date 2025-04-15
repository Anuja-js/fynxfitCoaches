import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignalingController {
  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;

  final _firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': {'facingMode': 'user'},
      'audio': true,
    });

    localRenderer.srcObject = _localStream;

    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    });

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    _peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    _peerConnection!.onIceCandidate = (candidate) {
      _firestore.collection('calls/demoCall/candidates').add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
  }

  Future<void> receiveCall() async {
    final doc = await _firestore.collection('calls').doc('demoCall').get();
    final data = doc.data();

    if (data == null) throw Exception("No offer found");

    final offer = RTCSessionDescription(
      data['offer']['sdp'],
      data['offer']['type'],
    );

    await _peerConnection!.setRemoteDescription(offer);

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await _firestore.collection('calls').doc('demoCall').update({
      'answer': {
        'type': answer.type,
        'sdp': answer.sdp,
      }
    });

    _firestore.collection('calls/demoCall/candidates').snapshots().listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        final data = doc.doc.data()!;
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        _peerConnection!.addCandidate(candidate);
      }
    });
  }

  Future<void> disposeResources() async {
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    await _localStream?.dispose();
    await _peerConnection?.close();
  }
}
