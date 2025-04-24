import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  final String id;
  final String title;
  final String description;
  final String coachId;
  final String videoId;
  final DateTime createdAt;
  final String videoUrl;
  final String advantage;
  final String repetitions;
  final String set;
  final String category;
  final String intensity;
  final String muscle;
  final String thumbnailUrl;
  final String workoutPrice;
  final String workoutOption;
  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.coachId,
    required this.videoId,
    required this.createdAt,
    required this.videoUrl,
    required this.category,
    required this.set,
    required this.advantage,
    required this.intensity,
    required this.muscle,
    required this.repetitions,required this.thumbnailUrl,
    required this.workoutOption,
    required this.workoutPrice
  });

  // 🔹 Convert Firestore Document to Workout Model
  factory Workout.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['subtitle'] ?? '', // ✅ Fixed the key
      coachId: data['coachId'] ?? '',
      videoId: data['videoId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      videoUrl: data['videoUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      advantage: data['advantages'] ?? '',
      repetitions: data['repetitions'] ?? '',
      set: data['sets'] ?? '',
      category: data['category'] ?? '',
      intensity: data['intensity'] ?? '',
      muscle: data['muscle'] ?? '',
      workoutPrice: data["workoutPrice"]??"",
      workoutOption: data["workoutOption"]??""
    );
  }

  // 🔹 Convert Workout Model to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "subtitle": description,
      "videoId": videoId,
      "coachId": coachId,
      "createdAt": FieldValue.serverTimestamp(),
      "videoUrl": videoUrl,
      "thumbnailUrl":thumbnailUrl,
      "advantages": advantage,
      "repetitions": repetitions,
      "sets": set,
      "category": category,
      "intensity": intensity,
      "muscle": muscle,
      "workoutOption":workoutOption,
      "workoutPrice":workoutPrice
    };
  }
}
