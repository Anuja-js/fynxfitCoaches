import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  WorkoutBloc() : super(WorkoutInitial()) {
    on<UploadWorkoutVideoEvent>(_uploadWorkoutVideo);
  }

  Future<void> _uploadWorkoutVideo(
      UploadWorkoutVideoEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(WorkoutFailure("User is not authenticated"));
        return;
      }

      Map<String, dynamic> videoData =
      await uploadVideoToCloudinary(event.videoPath);

      DocumentReference docRef =
      await _firestore.collection("workouts").add({
        "title": event.workoutTitle,
        "subtitle": event.workoutDescription,
        "videoUrl": videoData["secure_url"],
        "imageId": videoData["public_id"],
        "createdAt": FieldValue.serverTimestamp(),
        "userId": user.uid,
      });

      await docRef.update({"documentId": docRef.id});

      emit(WorkoutSuccess());
    } catch (e) {
      emit(WorkoutFailure(e.toString()));
    }
  }

  Future<Map<String, dynamic>> uploadVideoToCloudinary(String filePath) async {
    try {
      String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/video/upload";

      String uploadPreset = CloudinaryConstants.CLOUDINARY_UPLOAD_PRESET;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: "video.mp4"),
        "upload_preset": uploadPreset,
        "resource_type": "video",
      });

      Response response = await Dio().post(cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        return {
          "secure_url": response.data["secure_url"],
          "public_id": response.data["public_id"],
        };
      } else {
        throw Exception("Failed to upload video");
      }
    } catch (e) {
      print("Error uploading video: $e");
      throw e;
    }
  }
}
