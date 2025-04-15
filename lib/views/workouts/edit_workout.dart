import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/category/category_bloc.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_bloc.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_event.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_state.dart';
import 'package:fynxfitcoaches/models/workout_model.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/workouts/workout_list.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class WorkoutEditPage extends StatefulWidget {
  final Workout workout;
  WorkoutEditPage({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutEditPageState createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends State<WorkoutEditPage> {
  late TextEditingController titleController,
      descriptionController,
      advantageController,
      repetitionController,
      setController;
  File? _selectedVideo, selectedThumbnail;
  final ImagePicker picker = ImagePicker();
  String? selectedCategory, selectedIntensity, selectedMuscle;
  late VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.workout.title);
    descriptionController =
        TextEditingController(text: widget.workout.description);
    advantageController = TextEditingController(text: widget.workout.advantage);
    repetitionController =
        TextEditingController(text: widget.workout.repetitions);
    setController = TextEditingController(text: widget.workout.set);
    selectedCategory = widget.workout.category;
    selectedIntensity = widget.workout.intensity;
    selectedMuscle = widget.workout.muscle;

    if (widget.workout.videoUrl.isNotEmpty) {
      videoController = VideoPlayerController.network(widget.workout.videoUrl)
        ..initialize().then((_) => setState(() {}));
    }
  }

  Future<void> pickVideo() async {
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
        videoController = VideoPlayerController.file(_selectedVideo!)
          ..initialize().then((_) => setState(() {}));
      });
    }
  }

  Future<void> pickThumbnail() async {
    final XFile? pickedThumbnailFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedThumbnailFile != null) {
      setState(() => selectedThumbnail = File(pickedThumbnailFile.path));
    }
  }

  void updateWorkout() {
    if (titleController.text.isNotEmpty) {
      context.read<WorkoutBloc>().add(UpdateWorkoutEvent(
            workoutId: widget.workout.id,
            videoPath: _selectedVideo?.path ?? "",
            title: titleController.text,
            description: descriptionController.text,
            workoutCategory: selectedCategory.toString(),
            workoutIntensity: selectedIntensity!,
            workoutMuscle: selectedMuscle!,
            workoutAdvantage: advantageController.text,
            workoutRepetition: repetitionController.text,
            workoutSet: setController.text,
            thumbnailPath: selectedThumbnail?.path ?? "",
          ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please enter a title")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: CustomText(
            text: "Edit Workout", fontSize: 18.sp, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Colors.white, size: 20),
        ),
      ),
      body: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Workout updated successfully!")));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) {
              return WorkoutListPage();
            }));
          } else if (state is WorkoutFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (videoController != null &&
                    videoController!.value.isInitialized)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    ),
                  ),
                sh10,
                Center(
                  child: CustomElevatedButton(
                      text: "Pick New Video", onPressed: pickVideo),
                ),
                sh20,
                if (widget.workout.thumbnailUrl.isNotEmpty &&
                    selectedThumbnail == null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(widget.workout.thumbnailUrl,
                          height: 120, width: 120, fit: BoxFit.cover),
                    ),
                  ),
                if (selectedThumbnail != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(selectedThumbnail!,
                          height: 120, width: 120, fit: BoxFit.cover),
                    ),
                  ),
                sh10,
                Center(
                  child: CustomElevatedButton(
                      text: "Pick New Thumbnail", onPressed: pickThumbnail),
                ),
                sh20,
                CustomTextField(
                    controller: titleController, labelText: "Title"),
                sh20,
                CustomTextField(
                  controller: descriptionController,
                  labelText: "Description",
                  maxLines: 120,
                  overflow: TextOverflow.visible,
                ),
                sh20,
                CustomTextField(
                    controller: advantageController, labelText: "Advantage"),
                sh20,
                CustomTextField(
                    controller: repetitionController, labelText: "Repetitions"),
                sh20,
                CustomTextField(controller: setController, labelText: "Sets"),
                sh20,
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is CategoryError) {
                      return CustomText(text: "Error: ${state.message}");
                    } else if (state is CategoryLoaded) {
                      return DropdownButtonFormField<String>(
                        value: state.selectedCategory,
                        hint: const CustomText(
                            text: "Select Category", ),
                        dropdownColor:
                            Colors.grey[800], // Dark dropdown background
                        items: state.categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: CustomText(
                                text: category,
                                fontSize: 13.sp,
                                color: Colors.white),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            selectedCategory=newValue;
                            context
                                .read<CategoryBloc>()
                                .add(SelectCategory(newValue));
                          }
                        },
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white), // White arrow icon
                        style:
                            const TextStyle(color: Colors.white), // White text style
                      );
                    }
                    return Container(); // Default empty state
                  },
                ),
                DropdownButtonFormField(
                    value: selectedIntensity,
                    items: ["Beginner", "Intermediate", "Advanced"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (newValue) =>
                        setState(() => selectedIntensity = newValue)),
                DropdownButtonFormField(
                    value: selectedMuscle,
                    items: ["Legs", "Arms", "Core", "Back", "Shoulders"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (newValue) =>
                        setState(() => selectedMuscle = newValue)),
                sh20,
                Center(
                  child: CustomElevatedButton(
                      text: "Update Workout", onPressed: updateWorkout),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
