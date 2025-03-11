abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}
class WorkoutLoading extends WorkoutState {}
class WorkoutSuccess extends WorkoutState {}
class WorkoutFailure extends WorkoutState {
  final String error;
  WorkoutFailure(this.error);
}
