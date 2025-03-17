
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
    on<UploadWorkoutVideoEvent>(_uploadWorkoutVideo);
    on<DeleteWorkoutEvent>(_deleteWorkout);

    on<FetchCoachWorkoutsEvent>((event, emit) async {
      emit(WorkoutLoading());
      try {
        List<Workout> workouts = await fetchCoachWorkouts();
        emit(WorkoutsLoaded(workouts));
      } catch (e) {
        emit(WorkoutFailure(e.toString()));
      }
    });
    on<UpdateWorkoutEvent>(_updateWorkout);
  }

  Future<void> _uploadWorkoutVideo(UploadWorkoutVideoEvent event,
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

  Future<void> _updateWorkout(UpdateWorkoutEvent event,
      Emitter<WorkoutState> emit) async {
    print("jhgcfdooooooooooooooooo0");
    emit(WorkoutLoading());
    try {
      String? newVideoUrl;
      String? newImageId;

      // Fetch the existing workout details
      DocumentSnapshot docSnapshot =
      await _firestore.collection("workouts").doc(event.workoutId).get();
      Map<String, dynamic>? existingData =
      docSnapshot.data() as Map<String, dynamic>?;

      if (existingData == null) {
        emit(WorkoutFailure("Workout not found"));
        return;
      }

      // Retain existing values
      String oldVideoUrl = existingData["videoUrl"] ?? "";
      String oldImageId = existingData["imageId"] ?? "";

      // If a new video is provided, upload it to Cloudinary
      if (event.newVideoPath != null) {
        Map<String, dynamic> videoData =
        await uploadVideoToCloudinary(event.newVideoPath!);
        newVideoUrl = videoData["secure_url"];
        newImageId = videoData["public_id"];
      } else {
        newVideoUrl = oldVideoUrl;
        newImageId = oldImageId;
      }

      // Prepare the update map
      Map<String, dynamic> updateData = {
        "title": event.title,
        "subtitle": event.description,
        "videoUrl": newVideoUrl,
        "imageId": newImageId,

      };

      // Update Firestore document
      await _firestore.collection("workouts").doc(event.workoutId).update(
          updateData);

      List<Workout> updatedWorkouts = await fetchCoachWorkouts();
      emit(WorkoutsLoaded(updatedWorkouts)); // Emit updated list
    } catch (e) {
      emit(WorkoutFailure(e.toString()));
    }
  }

  Future<void> _deleteWorkout(
      DeleteWorkoutEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading()); // Show loading state

    try {

      await _firestore.collection("workouts").doc(event.workoutId).delete();
      List<Workout> updatedWorkouts = await fetchCoachWorkouts();
      emit(WorkoutsLoaded(updatedWorkouts));
    } catch (e) {
      emit(WorkoutFailure("Failed to delete workout: ${e.toString()}"));
    }
  }

//   Future<void> deleteVideoFromCloudinary(String imageId) async {
//     try {
//       String cloudinaryUrl =
//           "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/video/destroy";
//
//       String apiKey = CloudinaryConstants.CLOUDINARY_API_KEY;
//       String apiSecret = CloudinaryConstants.CLOUDINARY_API_SECRET;
//       String credentials = "$apiKey:$apiSecret";
//       String basicAuth = "Basic ${base64Encode(utf8.encode(credentials))}";
//
//       // FormData formData = FormData.fromMap({
//       //   "public_id": imageId, // Video ID on Cloudinary
//       //   "invalidate": true, // Clears the cache
//       // });
//       Map<String,dynamic> formData={
//           "public_id": imageId, // Video ID on Cloudinary
//           "invalidate": true, // Clears the cache
//       }
// ;
//       Response response = await Dio().post(
//         cloudinaryUrl,
//         data: formData,
//         options: Options(
//           headers: {
//             "Authorization": basicAuth, // Add authentication header
//           },
//         ),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception("Failed to delete video from Cloudinary: ${response.data}");
//       }
//     } catch (e) {
//       print("Error deleting video: $e");
//       throw e;
//     }
//   }


}
  // Future<void> deleteVideoFromCloudinary(String publicId) async {
  //   try {
  //     String cloudinaryUrl =
  //         "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/video/destroy";
  //
  //     Response response = await Dio().post(cloudinaryUrl, data: {
  //       "public_id": publicId,
  //       "invalidate": true,
  //     });
  //
  //     if (response.statusCode != 200) {
  //       throw Exception("Failed to delete video from Cloudinary");
  //     }
  //   } catch (e) {
  //     print("Error deleting video: $e");
  //     throw e;
  //   }
  // }
  //
  //
