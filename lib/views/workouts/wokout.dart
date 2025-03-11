import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_bloc.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_event.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class WorkoutAddPage extends StatefulWidget {
  @override
  _WorkoutAddPageState createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  void _uploadWorkout() {
    if (_selectedVideo != null && titleController.text.isNotEmpty) {
      context.read<WorkoutBloc>().add(
            UploadWorkoutVideoEvent(
              videoPath: _selectedVideo!.path,
              workoutTitle: titleController.text,
              workoutDescription: descriptionController.text,
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select a video and enter a title")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "Add Workout",
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        backgroundColor: AppThemes.darkTheme.appBarTheme.backgroundColor,
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: AppThemes.darkTheme.appBarTheme.foregroundColor,
              size: 15,
            )),
      ),
      body: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Workout uploaded successfully!")),
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
                CustomTextField(
                  controller: titleController,
                  hintText: "Workout Title",
                ),
                sh20,
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Workout Description",
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
                sh20,
                _selectedVideo == null
                    ? const CustomText(
                        text: "No video selected",
                      )
                    : CustomText(
                        text:
                            "Video selected: ${_selectedVideo!.path.split('/').last}"),
                sh10,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                    text: "Pick Workout Video",
                    onPressed: _pickVideo,
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                  ),
                ),
                sh10,
                BlocBuilder<WorkoutBloc, WorkoutState>(
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomElevatedButton(
                        text: "Upload Workout",
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                        onPressed: _uploadWorkout,
                      ),
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
