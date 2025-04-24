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
  final String workoutCategory;
  final String workoutIntensity;
  final String workoutMuscle;
  final String workoutAdvantage;
  final String workoutRepetition;
  final String workoutSet;
  final String thumbnailPath;
  final String workoutPrice;
  final String   workoutOption;
  // final String workoutType;
  UploadWorkoutVideoEvent(
      {required this.videoPath,
      required this.workoutTitle,
      required this.workoutDescription,
      required this.workoutAdvantage,
      required this.workoutCategory,
      required this.workoutIntensity,
      required this.workoutMuscle,
      required this.workoutRepetition,
      required this.workoutSet,
      required this.thumbnailPath,
        required this.workoutPrice,
        required this.workoutOption,
        // required this.workoutType,
      });

  @override
  List<Object?> get props => [
        videoPath,
        workoutTitle,
        workoutDescription,
        workoutMuscle,
        workoutSet,
        workoutRepetition,
        workoutAdvantage,workoutIntensity,workoutCategory,thumbnailPath
      ];
}

// 🔹 Fetch Workouts for the Logged-in Coach
class FetchCoachWorkoutsEvent extends WorkoutEvent {}

class UpdateWorkoutEvent extends WorkoutEvent {
  final String workoutId;
  final String title;
  final String description;
  final String workoutAdvantage;
  final String workoutRepetition;
  final String workoutSet;
  final String workoutCategory;
  final String workoutIntensity;
  final String workoutMuscle;
  final String videoPath;
  final String thumbnailPath;
  final String workoutPrice;
  final String workoutOption;

  UpdateWorkoutEvent({
    required this.workoutId,
    required this.title,
    required this.description,
    required this.workoutAdvantage,
    required this.workoutRepetition,
    required this.workoutSet,
    required this.workoutCategory,
    required this.workoutIntensity,
    required this.workoutMuscle,
    required this.videoPath,
    required this.thumbnailPath,
    required this.workoutPrice,
    required this.workoutOption,

  });
}


//   @override
//   List<Object?> get props => [workoutId, title, description];
// }

// 🔹 Delete Workout

class DeleteWorkoutEvent extends WorkoutEvent {
  final String workoutId;
  final String videoId;

  DeleteWorkoutEvent({required this.workoutId, required this.videoId});
}
