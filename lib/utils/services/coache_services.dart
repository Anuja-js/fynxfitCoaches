import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoachService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveCoachData(String userId, String selectedGender) async {
    try {
      await _firestore.collection('coaches').doc(userId).set({
        'uid': userId,
        'gender': selectedGender,
      }, SetOptions(merge: true)); // Prevents overwriting existing data
    } catch (e) {
      print("Error saving coach data: $e");
    }
  }
  Future<void> saveCoachBirthData(String userId, DateTime birthday) async {
    try {
      await _firestore.collection('coaches').doc(userId).set({
        'uid': userId,
        'birthday': Timestamp.fromDate(birthday),
      }, SetOptions(merge: true)); // Prevents overwriting existing data
    } catch (e) {
      print("Error saving coach data: $e");
    }
  }Future<void> saveCoachWeightData(String userId, double weight, bool isKgUnit) async {
    try {
      await _firestore.collection('coaches').doc(userId).set({
        'uid': userId,
        'weight': weight.toStringAsFixed(2), // Store weight in selected format
        'unit': isKgUnit ? 'kg' : 'lb', // Store unit type
      }, SetOptions(merge: true));

      print("Weight saved successfully");
    } catch (e) {
      print("Error saving weight: $e");
    }
  }Future<void> saveCoachHeightData(String userId, double height, bool isCm) async {
    try {
      await _firestore.collection('coaches').doc(userId).set({
        'uid': userId,
        'height': height.toStringAsFixed(2),
        'unitheight': isCm? 'cm' : 'in', // Store unit type
      }, SetOptions(merge: true));

      print("Height saved successfully");
    } catch (e) {
      print("Error saving weight: $e");
    }
  }

  Future<void> saveCoachBasicInfo({
  required String userId,
  required String name,
  required String experience,
  required String expertise,
  required String bio,
  }) async {
  try {
  await _firestore.collection('coaches').doc(userId).set({
  'uid': userId,
  'name': name,
  'experience': experience,
  'expertise': expertise,
  'bio': bio,
  }, SetOptions(merge: true)); // Prevents overwriting existing data

  print("Basic Information saved successfully");
  } catch (e) {
  print("Error saving basic info: $e");
  }
  }
  }


