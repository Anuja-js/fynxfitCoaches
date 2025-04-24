import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowersListScreen extends StatelessWidget {
  final String userId;

  const FollowersListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Followers"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('followers')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final followers = snapshot.data?.docs ?? [];

          if (followers.isEmpty) {
            return const Center(child: Text("No followers yet."));
          }

          return ListView.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              final followerId = followers[index].id;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(followerId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  final userData = userSnapshot.data!;
                  final name = userData['name'] ?? 'Unknown';
                  final email = userData['email'] ?? '';

                  return ListTile(
                    leading:  Image.network(userData['profileImageUrl'],fit: BoxFit.cover,width: 50,height: 50,),
                    title: Text(name),
                    subtitle: Text(email),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
