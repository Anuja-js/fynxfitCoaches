import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../../bloc/workouts/workout_bloc.dart';
import '../../bloc/workouts/workout_event.dart';
import '../../bloc/workouts/workout_state.dart';
import '../../models/workout_model.dart';
import '../../theme.dart';
import '../../utils/constants.dart';
import '../../widgets/customs/custom_elevated_button.dart';
import '../../widgets/customs/custom_text.dart';
import '../../widgets/customs/custom_text_field.dart';

class EditWorkoutPage extends StatefulWidget {
  final Workout workout;

  const EditWorkoutPage({Key? key, required this.workout}) : super(key: key);

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.workout.title;
    descriptionController.text = widget.workout.description;
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  void _updateWorkout() {
    print("oooooooooooooooooooooooooooooooooo");
    if (titleController.text.isNotEmpty) {
      context.read<WorkoutBloc>().add(
        UpdateWorkoutEvent(
          workoutId: widget.workout.id,
          title: titleController.text,
          description: descriptionController.text,
          newVideoPath: _selectedVideo?.path, // Pass new video path if selected
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updating workout...")),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
        return MainPage();
      }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(text: "Edit Workout", fontSize: 16, fontWeight: FontWeight.bold),
        elevation: 0,
        backgroundColor: AppThemes.darkTheme.appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white, size: 15),
        ),
      ),
      body: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Workout updated successfully!")),
            );
            Navigator.pop(context);
          } else if (state is WorkoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(controller: titleController, hintText: "Workout Title"),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Workout Description",
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                _selectedVideo == null
                    ? CustomText(text: "Current video: ${widget.workout.videoUrl}")
                    : CustomText(text: "New video selected: ${_selectedVideo!.path.split('/').last}"),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                    text: "Change Workout Video",
                    onPressed: _pickVideo,
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<WorkoutBloc, WorkoutState>(
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            text: "Update Workout",
                            backgroundColor: AppThemes.darkTheme.primaryColor,
                            textColor: Colors.white,
                            onPressed: _updateWorkout
                          ),
                        ),
                        sw10,
                        Expanded(
                          child: CustomElevatedButton(
                            text: "Cancel",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
