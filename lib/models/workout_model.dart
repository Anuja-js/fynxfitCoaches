import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String id;
  final String title;
  final String description;
  final String coachId;
  final DateTime createdAt;
  final String videoUrl;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.coachId,
    required this.createdAt,
    required this.videoUrl
  });

  // 🔹 Convert Firestore Document to Workout Model
  factory Workout.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['subtitle'] ?? '',
      coachId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      videoUrl: data['videoUrl'] ?? '',
    );
  }

  // 🔹 Convert Workout Model to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "description": description,
      "coachId": coachId,
      "createdAt": FieldValue.serverTimestamp(),
      "videoUrl":videoUrl
    };
  }
}
