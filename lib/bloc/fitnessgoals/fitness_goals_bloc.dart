import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_event.dart';
import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_state.dart';
import 'package:fynxfitcoaches/models/goals_model.dart';

class FitnessGoalBloc extends Bloc<FitnessGoalEvent, FitnessGoalState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FitnessGoalBloc()
      : super(FitnessGoalState(selectedGoals: [], goals: [], isLoading: false)) {
    on<LoadGoals>(_fetchGoals);
    on<ToggleGoalSelection>(_toggleGoalSelection);
  }
  Future<void> _fetchGoals(LoadGoals event, Emitter<FitnessGoalState> emit) async {
    try {
      emit(FitnessGoalState(selectedGoals: state.selectedGoals, goals: state.goals, isLoading: true));

      QuerySnapshot querySnapshot = await _firestore.collection('category').get();

      List<Goal> fetchedGoals = querySnapshot.docs.map((doc) {
        return Goal(
          title: doc['title'] as String? ?? 'Unknown Goal',
          imageUrl: doc['imageUrl'] as String? ?? '',
        );
      }).toList();

      emit(FitnessGoalState(selectedGoals: state.selectedGoals, goals: fetchedGoals, isLoading: false));
    } catch (e) {
      emit(FitnessGoalState(
        selectedGoals: state.selectedGoals,
        goals: [],
        isLoading: false,
        error: "Error loading goals: ${e.toString()}",
      ));
    }
  }

  void _toggleGoalSelection(ToggleGoalSelection event, Emitter<FitnessGoalState> emit) async {
    List<Goal> updatedGoals = List.from(state.selectedGoals);

    final goalIndex = updatedGoals.indexWhere((goal) => goal.title == event.goalTitle);

    if (goalIndex != -1) {
      updatedGoals.removeAt(goalIndex);
    } else {
      final selectedGoal = state.goals.firstWhere((goal) => goal.title == event.goalTitle);
      updatedGoals.add(selectedGoal);
    }

    emit(FitnessGoalState(selectedGoals: updatedGoals, goals: state.goals, isLoading: false));

    await _saveSelectedGoalsToFirestore(event.uid, updatedGoals);
  }

  Future<void> _saveSelectedGoalsToFirestore(String userId, List<Goal> selectedGoals) async {
    try {
      List<Map<String, dynamic>> goalsData = selectedGoals.map((goal) => {
        'title': goal.title,
        'imageUrl': goal.imageUrl,
      }).toList();

      await _firestore.collection('coaches').doc(userId).set({
        'selectedGoals': goalsData, // Ensure Firestore stores it correctly
      }, SetOptions(merge: true));

      print("Selected goals saved successfully");
    } catch (e) {
      print("Error saving selected goals: $e");
    }
  }
}
