import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/infocoach/coach_info_bloc.dart';
import 'package:fynxfitcoaches/bloc/infocoach/coach_info_event.dart';
import 'package:fynxfitcoaches/bloc/infocoach/coach_info_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/utils/services/coache_services.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

class BasicInformationScreen extends StatelessWidget {
  final PageController controller;
  final String uid;

  BasicInformationScreen({Key? key, required this.controller, required this.uid}) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: BlocBuilder<BasicInfoBloc, BasicInfoState>(
          builder: (context, state) {
            String type = "";
            String experience = "";
            String expertise = "";
            String bio = "";

            if (state is BasicInfoUpdated) {
              type = state.name;
              experience = state.experience;
              expertise = state.expertise;
              bio = state.bio;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh30,
                CustomText(text: "Tell Us About Yourself", fontSize: 18.sp, fontWeight: FontWeight.bold),
                sh20,
                CustomText(
                  text: "Provide your basic details to personalize your coaching experience.",overflow: TextOverflow.visible,
                  fontSize: 12.sp,
                  color: AppThemes.darkTheme.dividerColor,
                ),
                sh20,
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: "Type Name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<BasicInfoBloc>().add(UpdateName(value));
                  },
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField<String>(
                  value: experience.isEmpty ? null : experience,
                  decoration: InputDecoration(
                    labelText: "Select Experience",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ["Beginner", "Intermediate", "Advanced"].map((exp) {
                    return DropdownMenuItem(value: exp, child: Text(exp));
                  }).toList(),
                  onChanged: (value) => context.read<BasicInfoBloc>().add(UpdateExperience(value!)),
                ),
                SizedBox(height: 10.h),
                DropdownButtonFormField<String>(
                  value: expertise.isEmpty ? null : expertise,
                  decoration: InputDecoration(
                    labelText: "Select Expertise",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    "Strength Training",
                    "Bodybuilding",
                    "Cardio Fitness",
                    "Yoga & Flexibility",
                    "CrossFit & Functional Training",
                    "Endurance & Stamina",
                    "Weight Management",
                    "All"
                  ].map((exp) {
                    return DropdownMenuItem(value: exp, child: Text(exp));
                  }).toList(),
                  onChanged: (value) => context.read<BasicInfoBloc>().add(UpdateExpertise(value!)),
                ),
                SizedBox(height: 10.h),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Bio",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                  onChanged: (value) => context.read<BasicInfoBloc>().add(UpdateBio(value)),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                    text: "Next",
                    onPressed: () async {
                      if (state is BasicInfoUpdated) {
                        await CoachService().saveCoachBasicInfo(
                          name: state.name,
                          experience: state.experience,
                          expertise: state.expertise,
                          bio: state.bio,
                          userId: uid,
                        );

                        context.read<BasicInfoBloc>().add(SubmitBasicInfo(uid));

                        await Future.delayed(Duration(milliseconds: 200));

                        if (context.mounted && controller.hasClients) {
                          controller.animateToPage(
                            2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );}

                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
