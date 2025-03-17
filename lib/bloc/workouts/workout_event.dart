import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class WorkoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// 🔹 Upload Workout Video
class UploadWorkoutVideoEvent extends WorkoutEvent {
  final String videoPath;
  final String workoutTitle;
  final String workoutDescription;

  UploadWorkoutVideoEvent({
    required this.videoPath,
    required this.workoutTitle,
    required this.workoutDescription,
  });

  @override
  List<Object?> get props => [videoPath, workoutTitle, workoutDescription];
}

// 🔹 Fetch Workouts for the Logged-in Coach
class FetchCoachWorkoutsEvent extends WorkoutEvent {}

class UpdateWorkoutEvent extends WorkoutEvent {
  final String workoutId;
  final String title;
  final String description;
  final String? newVideoPath; // Nullable for optional video updates

  UpdateWorkoutEvent({
    required this.workoutId,
    required this.title,
    required this.description,
    this.newVideoPath, // Add newVideoPath for video updates
  });
}


//   @override
//   List<Object?> get props => [workoutId, title, description];
// }

// 🔹 Delete Workout

class DeleteWorkoutEvent extends WorkoutEvent {
  final String workoutId;

  DeleteWorkoutEvent({required this.workoutId});
}


