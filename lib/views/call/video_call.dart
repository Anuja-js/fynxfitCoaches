import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CoachCallScreen extends StatefulWidget {
  final String userId; // 💡 Pass the user ID to know who is calling
  const CoachCallScreen({super.key, required this.userId});

  @override
  State<CoachCallScreen> createState() => _CoachCallScreenState();
}

class _CoachCallScreenState extends State<CoachCallScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final int appID = 2141926597;
  final String appSign = "0e3dcf791edb2de436b05850732ece53c4b5809a0956a62fc07c302978f1d089";

  String generateRoomID(String id1, String id2) {
    final sorted = [id1, id2]..sort();
    return sorted.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final coachId = user?.uid ?? 'coach_guest';
    final coachName = user?.displayName ?? "Coach";

    final roomID = generateRoomID(widget.userId, coachId);

    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: coachId,
        userName: coachName,
        callID: roomID,
        plugins: [ZegoUIKitSignalingPlugin()],
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}
