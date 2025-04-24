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

import '../../bloc/category/category_bloc.dart';

class WorkoutAddPage extends StatefulWidget {
  @override
  _WorkoutAddPageState createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController advantageController = TextEditingController();
  final TextEditingController repetitionController = TextEditingController();
  final TextEditingController setController = TextEditingController();
  File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();
  File? selectedThumbnail;
  String? selectedCategory;
  String? selectedIntensity;
  String? selectedMuscle;
  String? selectedPriceOption;
  String? selectedPrice;


  final List<String> intensities = ["Beginner", "Intermediate", "Advanced"];
  final List<String> muscles = ["Legs", "Arms", "Core", "Back", "Shoulders"];

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }


  Future<void> pickThumbnail() async {
    final XFile? pickedThabnailFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedThabnailFile != null) {
      setState(() {
        selectedThumbnail = File(pickedThabnailFile.path);
      });
    }

  }

  void uploadWorkout() {
    if (_selectedVideo != null &&
        selectedThumbnail != null &&
        titleController.text.isNotEmpty &&
        selectedIntensity != null &&
        selectedMuscle != null &&
        selectedCategory != null &&
        selectedPriceOption != null&&(selectedPriceOption == "Free" || cashController.text.isNotEmpty)) {
      context.read<WorkoutBloc>().add(
        UploadWorkoutVideoEvent(
          videoPath: _selectedVideo!.path,
          workoutTitle: titleController.text,
          workoutDescription: descriptionController.text,
          workoutCategory: selectedCategory!,
          workoutIntensity: selectedIntensity!,
          workoutMuscle: selectedMuscle!,
          workoutAdvantage: advantageController.text,
          workoutRepetition: repetitionController.text,
          workoutSet: setController.text,
          thumbnailPath: selectedThumbnail!.path,
          workoutPrice: cashController.text,
          workoutOption: selectedPriceOption!,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
    }
  }
  final List<String> priceOptions = ["Free", "Paid"];
  final TextEditingController cashController = TextEditingController();

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
                  labelText: "Title",
                ),
                sh20,
                CustomTextField(
                  controller: descriptionController,
                  labelText: "Description",
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
                sh20,    CustomTextField(
                  controller: advantageController,
                  labelText: "Advantage",
                  maxLines: null,
                  minLines: 1,
                ),
                sh20,
                CustomTextField(
                  controller: repetitionController,
                  labelText: "Repetitions",
                ),
                sh20,
                CustomTextField(
                  controller: setController,
                  labelText: "Sets",
                ),
                sh20,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return CircularProgressIndicator();
                } else if (state is CategoryError) {
                  return CustomText(text: "Error: ${state.message}");
                } else if (state is CategoryLoaded) {
                  return DropdownButtonFormField<String>(
                    value: state.selectedCategory,
                    hint: CustomText(text: "Select Category", color: Colors.white),
                    dropdownColor: Colors.grey[800], // Dark dropdown background
                    items: state.categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: CustomText(text: category, fontSize: 13.sp, color: Colors.white),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        selectedCategory=newValue;
                        context.read<CategoryBloc>().add(SelectCategory(newValue));
                      }
                    },
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white), // White arrow icon
                    style: TextStyle(color: Colors.white), // White text style
                  );
                }
                return Container(); // Default empty state
              },
            ),
                sh20,
                DropdownButtonFormField<String>(
                  value: selectedIntensity, dropdownColor: Colors.grey[800],
                  hint: CustomText(text: "Select Intensity",),
                  items: intensities.map((String intensity) {
                    return DropdownMenuItem<String>(
                      value: intensity,
                      child: CustomText(text: intensity,),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedIntensity = newValue;
                    });
                  },
                ),
                sh10,
                DropdownButtonFormField<String>(
                  value: selectedPriceOption, dropdownColor: Colors.grey[800],
                  hint: CustomText(text: "Select Price Option"),
                  items: priceOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: CustomText(text: option,),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriceOption = newValue;
                    });
                  },
                ),
                if (selectedPriceOption == "Paid") ...[
                  sh20,
                  TextFormField(
                    controller: cashController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                sh10,


                DropdownButtonFormField<String>(
                  value: selectedMuscle, dropdownColor: Colors.grey[800],
                  hint: CustomText(text: "Select Target Muscle",),
                  items: muscles.map((String muscle) {
                    return DropdownMenuItem<String>(
                      value: muscle,
                      child: CustomText(text: muscle,),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedMuscle = newValue;
                    });
                  },
                ),
                sh20,
                selectedThumbnail == null
                    ? const CustomText(text: "No thumbnail selected")
                    : Image.file(
                  selectedThumbnail!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),

                sh10,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                    text: "Pick Thumbnail",
                    onPressed: pickThumbnail,
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                  ),
                ),
                sh20,

                _selectedVideo == null
                    ? const CustomText(text: "No video selected")
                    : CustomText(text: "Video selected: ${_selectedVideo!.path.split('/').last}"),
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
                        onPressed: uploadWorkout,
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
