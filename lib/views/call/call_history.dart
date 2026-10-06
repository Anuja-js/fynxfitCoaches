import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallHistoryPage extends StatelessWidget {
  final String userId;

  const CallHistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Call History")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> callHistory = userData['callHistory'] ?? [];

          if (callHistory.isEmpty) {
            return const Center(child: Text('No call history yet.'));
          }

          return ListView.builder(
            itemCount: callHistory.length,
            itemBuilder: (context, index) {
              final call = callHistory[index] as Map<String, dynamic>;
              final String callWith = call['callWith'] ?? 'Unknown';
              final String type = call['type'] ?? 'audio';
              final int duration = call['duration'] ?? 0;
              final Timestamp timestamp = call['timestamp'] ?? Timestamp.now();

              final DateTime dateTime = timestamp.toDate();
              final String formattedTime = DateFormat('dd MMM, hh:mm a').format(dateTime);

              return ListTile(
                leading: Icon(
                  type == 'video' ? Icons.videocam : Icons.phone,
                  color: type == 'video' ? Colors.purple : Colors.green,
                ),
                title: Text("Call with $callWith"),
                subtitle: Text("$formattedTime • Duration: ${duration}s"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          );
        },
      ),
    );
  }
}
