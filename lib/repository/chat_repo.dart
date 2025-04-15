import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getMessagedUsersData(String coachId) {
    return _firestore
        .collection("chats")
        .where("users", arrayContains: coachId) // Fetch chats involving the coach
        .snapshots()
        .asyncMap((snapshot) async {
      Set<String> userIds = {}; // Store unique user IDs

      for (var doc in snapshot.docs) {
        List<dynamic> users = doc["users"];
        String userId = users.firstWhere((id) => id != coachId).toString();
        userIds.add(userId);
      }

      // Fetch user details from the "users" collection
      List<Map<String, dynamic>> userDetails = [];

      for (String id in userIds) {
        var userDoc = await _firestore.collection("users").doc(id).get();
        if (userDoc.exists) {
          userDetails.add(userDoc.data()!);
        }
      }

      return userDetails;
    });
  }
}
