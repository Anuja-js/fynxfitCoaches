abstract class FitnessGoalEvent {}

class LoadGoals extends FitnessGoalEvent {}

class ToggleGoalSelection extends FitnessGoalEvent {
  final String goalTitle;
  final String uid;

  ToggleGoalSelection({required this.goalTitle, required this.uid});
}class SaveSelectedGoals extends FitnessGoalEvent {
  final String uid;
  SaveSelectedGoals({required this.uid});
}


