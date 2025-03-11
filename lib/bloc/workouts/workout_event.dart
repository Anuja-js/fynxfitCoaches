abstract class WorkoutEvent {}

class UploadWorkoutVideoEvent extends WorkoutEvent {
  final String videoPath;
  final String workoutTitle;
  final String workoutDescription;

  UploadWorkoutVideoEvent({required this.videoPath, required this.workoutTitle, required this.workoutDescription});
}
