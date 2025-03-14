import 'package:fynxfitcoaches/models/goals_model.dart';

class FitnessGoalState {
  final List<Goal> selectedGoals;
  final List<Goal> goals;
  final bool isLoading;
  final String? error;

  FitnessGoalState({
    required this.selectedGoals,
    required this.goals,
    required this.isLoading,
    this.error,
  });
}
