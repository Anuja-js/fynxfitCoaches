import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_bloc.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_event.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_state.dart';
import 'package:fynxfitcoaches/models/workout_model.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

import 'edit_workout.dart';

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutBloc>().add(FetchCoachWorkoutsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "My Workouts",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        backgroundColor: AppThemes.darkTheme.appBarTheme.backgroundColor,
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: state.workouts.length,
              itemBuilder: (context, index) {
                final workout = state.workouts[index];
                return Card(
                  color: AppThemes.darkTheme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: CustomText(
                      text: workout.title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: CustomText(
                      text: workout.description,
                      fontSize: 12,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                              return EditWorkoutPage(workout: workout);
                            }));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, workout);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is WorkoutFailure) {
            return Center(child: CustomText(text: "Error: ${state.error}"));
          }
          return const Center(child: CustomText(text: "No workouts found."));
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Workout"),
        content: const Text("Are you sure you want to delete this workout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<WorkoutBloc>().add(DeleteWorkoutEvent(workoutId: workout.id));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
