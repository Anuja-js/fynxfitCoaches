import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import '../../models/workout_model.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WorkoutBloc() : super(WorkoutInitial()) {
    on<UploadWorkoutVideoEvent>(uploadWorkoutVideo);
    on<DeleteWorkoutEvent>(deleteWorkout);

    on<FetchCoachWorkoutsEvent>((event, emit) async {
      emit(WorkoutLoading());
      try {
        List<Workout> workouts = await fetchCoachWorkouts();
        emit(WorkoutsLoaded(workouts));
      } catch (e) {
        emit(WorkoutFailure(e.toString()));
      }
    });
    on<UpdateWorkoutEvent>(updateWorkout);
  }

  Future<void> uploadWorkoutVideo(UploadWorkoutVideoEvent event,
      Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(WorkoutFailure("User is not authenticated"));
        return;
      }

      Map<String, dynamic> videoData =
      await uploadVideoToCloudinary(event.videoPath);

      Map<String, dynamic> thumnailData= await uploadImageToCloudinary(event.thumbnailPath);
      DocumentReference docRef =
      await _firestore.collection("workouts").add({
        "title": event.workoutTitle,
        "subtitle": event.workoutDescription,
        "advantages":event.workoutAdvantage,
        "repetitions":event.workoutRepetition,
        "sets":event.
          workoutSet,
        "category":event.workoutCategory,
        "intensity":event.workoutIntensity,
       "muscle" :event.workoutMuscle,
        'thumbUrl':thumnailData["secure_url"],
        'thumbid':thumnailData["public_id"],
        "videoUrl": videoData["secure_url"],
        "videoId": videoData["public_id"],
        "createdAt": FieldValue.serverTimestamp(),
        "userId": user.uid,
        "workoutPrice":event.workoutPrice,
        "workoutOption":event.workoutOption
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
          "https://api.cloudinary.com/v1_1/${CloudinaryConstants
          .CLOUDINARY_CLOUD_NAME}/video/upload";

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

  Future<List<Workout>> fetchCoachWorkouts() async {
    String? coachId = getCurrentCoachId();
    if (coachId == null) throw Exception("No logged-in coach found.");
    print(coachId);
    QuerySnapshot snapshot = await _firestore
        .collection("workouts")
        .where("userId", isEqualTo: coachId)
        .get();

    return snapshot.docs
        .map((doc) => Workout.fromFirestore(doc))
        .toList();
  }

  String? getCurrentCoachId() {
    return _auth.currentUser?.uid;
  }



  Future<void> updateWorkout(
      UpdateWorkoutEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(WorkoutFailure("User is not authenticated"));
        return;
      }
    final doc=  await _firestore.collection("workouts").doc(event.workoutId).get();

      // Upload video if updated
      String videoUrl = event.videoPath;
      if (event.videoPath != null && event.videoPath.isNotEmpty) {
        final videoData = await uploadVideoToCloudinary(event.videoPath);
        videoUrl = videoData["secure_url"];
      }else{
        videoUrl=
        doc["videoUrl"];

      }

      // Upload thumbnail if updated
      String thumbnailUrl = event.thumbnailPath;

      if (event.thumbnailPath != null && event.thumbnailPath.isNotEmpty) {
        final thumbnailData = await uploadImageToCloudinary(event.thumbnailPath);
        thumbnailUrl = thumbnailData["secure_url"]!;
      }else{
        thumbnailUrl=
        doc["thumbUrl"];

      }

      // Update Firestore document
      await _firestore.collection("workouts").doc(event.workoutId).update({
        "title": event.title,
        "subtitle": event.description,
        "advantages": event.workoutAdvantage,
        "repetitions": event.workoutRepetition,
        "sets": event.workoutSet,
        "category": event.workoutCategory,
        "intensity": event.workoutIntensity,
        "muscle": event.workoutMuscle,
        "videoUrl": videoUrl,
        "thumbnailUrl": thumbnailUrl,
        "workoutPrice":event.workoutPrice,
        "workoutOption":event.workoutOption,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      List<Workout> updatedWorkouts = await fetchCoachWorkouts();
      emit(WorkoutsLoaded(updatedWorkouts));
      emit(WorkoutSuccess());
    } catch (e) {
      emit(WorkoutFailure(e.toString()));
    }
  }

  Future<void> deleteWorkout(DeleteWorkoutEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    try {
      // Delete video from Cloudinary first
      await deleteCloudinaryVideo(event.videoId);

      // Delete workout from Firestore
      await _firestore.collection("workouts").doc(event.workoutId).delete();

      // Fetch updated workout list
      List<Workout> updatedWorkouts = await fetchCoachWorkouts();
      emit(WorkoutsLoaded(updatedWorkouts));

    } catch (e) {
      emit(WorkoutFailure("❌ Failed to delete workout: ${e.toString()}"));
    }
  }
  Future<void> deleteCloudinaryVideo(String publicId) async {
    try {
      String cloudName = "dswwx1kl4";
      String apiKey = "413491413778726";
      String apiSecret = "GBuMHcOy845fjoI8-2R36MR7UEE";

      // Encode API Key & Secret for Basic Authentication
      String authToken = base64Encode(utf8.encode("$apiKey:$apiSecret"));

      // Correct Cloudinary DELETE URL
      String url = "https://api.cloudinary.com/v1_1/$cloudName/resources/video/upload";

      // Request body with correct format
      Map<String, dynamic> params = {
        "public_ids": [publicId]
      };

      // Making the DELETE request
      Response response = await Dio().delete(
        url,
        data: params,
        options: Options(
          headers: {
            "Authorization": "Basic $authToken",
            "Content-Type": "application/json",
          },
          validateStatus: (status) {
            return status! < 500; // Allows Cloudinary to return status codes without throwing an error
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Cloudinary video deleted successfully");
      } else {
        print("⚠️ Failed to delete video. Status code: ${response.statusCode}");
        print("Response: ${response.data}");
      }
    } catch (e) {
      print("❌ Error deleting video from Cloudinary: $e");
    }
  }
  Future<Map<String, String>> uploadImageToCloudinary(String filePath) async {
    try {
      String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/image/upload";
      String uploadPreset = CloudinaryConstants.CLOUDINARY_UPLOAD_PRESET;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: "image.jpg"),
        "upload_preset": uploadPreset,
      });

      Response response = await Dio().post(cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        return {
          "secure_url": response.data["secure_url"],
          "public_id": response.data["public_id"],
        };
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }

}
