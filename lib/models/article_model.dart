import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String documentId;
  final String title;
  final String subtitle;
  final String imageId;
  final String imageUrl;
  final String userId;
  final DateTime createdAt;

  ArticleModel({
    required this.documentId,
    required this.title,
    required this.subtitle,
    required this.imageId,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
  });

  /// Convert Firestore DocumentSnapshot to ArticleModel
  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ArticleModel(
      documentId: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageId: data['imageId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert ArticleModel to JSON for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageId': imageId,
      'imageUrl': imageUrl,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
