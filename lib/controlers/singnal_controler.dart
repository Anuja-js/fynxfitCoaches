// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
//
// class JitsiCallController {
//   late final JitsiMeet jitsiMeet;
//   late final JitsiMeetConferenceOptions options;
//
//   JitsiCallController() {
//     jitsiMeet = JitsiMeet();
//   }
//
//   Future<void> joinMeeting({
//     required String room,
//     required String displayName,
//     String? email,
//     String? avatarUrl,
//     bool audioMuted = false,
//     bool videoMuted = false,
//   }) async {
//     options = JitsiMeetConferenceOptions(
//       serverURL: "https://meet.jit.si", // or your custom server
//       room: room,
//       configOverrides: {
//         "startWithAudioMuted": audioMuted,
//         "startWithVideoMuted": videoMuted,
//         "subject": "Brocamp Meeting",
//       },
//       featureFlags: {
//         "welcomepage.enabled": false,
//         "call-integration.enabled": false,
//       },
//       userInfo: JitsiMeetUserInfo(
//         displayName: displayName,
//         email: email,
//       ),
//     );
//
//     jitsiMeet.join(options);
//   }
//
//   void hangUp() {
//     jitsiMeet.hangUp();
//   }
//
//   void dispose() {
//     jitsiMeet.hangUp();
//   }
// }
