import '../../models/workout_model.dart';

abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutSuccess extends WorkoutState {}

class WorkoutFailure extends WorkoutState {
  final String error;
  WorkoutFailure(this.error);
}

class WorkoutsLoaded extends WorkoutState {
  final List<Workout> workouts;
  WorkoutsLoaded(this.workouts);
}

class WorkoutUpdated extends WorkoutState {}
