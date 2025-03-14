import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/gender/gender_selection_bloc.dart';
import 'package:fynxfitcoaches/bloc/gender/gender_selection_state.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/utils/services/coache_services.dart';
import '../../../theme.dart';
import '../../../widgets/customs/custom_elevated_button.dart';
import '../../../widgets/customs/custom_text.dart';
import '../../../widgets/gender/gender_option.dart';

class GenderSelectionScreen extends StatelessWidget {
  final PageController? controller;
  final String userId;

  GenderSelectionScreen({required this.controller, required this.userId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           sh30,
            CustomText(text: "Please Select An Option", fontSize: 13.sp),
            CustomText(
              text: "Tell Us Who You Are",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "This helps us personalize your fitness experience.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GenderOption(label: "Female", image: "assets/images/female.png"),
                GenderOption(label: "Male", image: "assets/images/male.png"),
                GenderOption(label: "Other", image: "assets/images/other.png"),
              ],
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BlocBuilder<GenderSelectionBloc, GenderSelectionState>(
                builder: (context, state) {
                  return CustomElevatedButton(
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                    text: "Next",
                    onPressed: () async {

                        if (state.selectedGender != null) {
                          await CoachService().saveCoachData(userId, state.selectedGender!);

                          if (controller != null && controller!.hasClients) {
                            controller!.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            print("PageController is not attached yet!");
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please select your gender")),
                          );
                        }


                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
