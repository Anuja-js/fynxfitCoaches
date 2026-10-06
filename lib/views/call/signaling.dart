import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  final String roomId;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final _firestore = FirebaseFirestore.instance;
  late final DocumentReference _roomRef;

  bool isCaller = false;
  DateTime? startTime; // ✅ Added to track call start time

  Signaling({
    required this.roomId,
    required this.localRenderer,
    required this.remoteRenderer,
  });

  Future<void> init({required bool isCaller}) async {
    this.isCaller = isCaller;
    startTime = DateTime.now(); // ✅ Capture call start time

    _roomRef = _firestore.collection('calls').doc(roomId);

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    log('🎥 Fetching local media');
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'},
    });
    log('📶 Local stream ID: ${_localStream?.id}');
    localRenderer.srcObject = _localStream;

    _peerConnection = await createPeerConnection(config);
    _peerConnection?.onConnectionState = (state) =>
        log('🔌 ConnectionState: $state');

    _peerConnection?.onIceCandidate = (candidate) {
      log('🧩 ICE candidate: ${candidate.candidate}');
      if (candidate.candidate != null) {
        _roomRef
            .collection(isCaller ? 'callerCandidates' : 'calleeCandidates')
            .add(candidate.toMap());
      }
    };

    _peerConnection?.onTrack = (event) {
      log('🎯 onTrack streams count: ${event.streams.length}');
      if (event.streams.isNotEmpty) {
        log('✅ Attaching remote stream ID: ${event.streams[0].id}');
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    _localStream?.getTracks().forEach((track) {
      log('➕ Adding local track: ${track.kind}');
      _peerConnection?.addTrack(track, _localStream!);
    });

    if (isCaller) {
      log('📞 Creating offer');
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      log('📨 Offer SDP set');
      await _roomRef.set({'offer': offer.toMap()});

      _roomRef.snapshots().listen((snap) {
        final data = snap.data() as Map<String, dynamic>?;
        if (data != null && data['answer'] != null) {
          log('📩 Received answer');
          final ans = data['answer'];
          _peerConnection?.setRemoteDescription(
            RTCSessionDescription(ans['sdp'], ans['type']),
          );
        }
      });

      _roomRef.collection('calleeCandidates').snapshots().listen((snap) {
        for (var c in snap.docChanges) {
          final d = c.doc.data();
          if (d != null) {
            log('📡 Adding callee ICE candidate');
            _peerConnection?.addCandidate(
              RTCIceCandidate(d['candidate'], d['sdpMid'], d['sdpMLineIndex']),
            );
          }
        }
      });
    } else {
      log('📲 Joining existing call');
      final doc = await _roomRef.get();
      final data = doc.data() as Map<String, dynamic>;
      log('📥 Got offer');
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(data['offer']['sdp'], data['offer']['type']),
      );

      log('📞 Creating answer');
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      await _roomRef.update({'answer': answer.toMap()});

      _roomRef.collection('callerCandidates').snapshots().listen((snap) {
        for (var c in snap.docChanges) {
          final d = c.doc.data();
          if (d != null) {
            log('📡 Adding caller ICE candidate');
            _peerConnection?.addCandidate(
              RTCIceCandidate(d['candidate'], d['sdpMid'], d['sdpMLineIndex']),
            );
          }
        }
      });
    }
  }

  Future<void> leaveCall() async {
    log('🛑 Ending call');
    await _peerConnection?.close();
    await _localStream?.dispose();
    remoteRenderer.srcObject = null;
    localRenderer.srcObject = null;

    final col = isCaller ? 'calleeCandidates' : 'callerCandidates';
    final snap = await _roomRef.collection(col).get();
    for (var doc in snap.docs) await doc.reference.delete();

    await _roomRef.delete();
  }
}
