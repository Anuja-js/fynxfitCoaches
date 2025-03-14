import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/birthday/birthday.event.dart';
import 'package:fynxfitcoaches/bloc/birthday/birthday_bloc.dart';
import 'package:fynxfitcoaches/bloc/birthday/birthday_state.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/utils/services/coache_services.dart';
import '../../../theme.dart';
import '../../../widgets/customs/custom_elevated_button.dart';
import '../../../widgets/customs/custom_text.dart';

class BirthdayScreen extends StatelessWidget {
  final PageController? controller;
String? uid;
  BirthdayScreen({required this.controller, required this.uid,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sh30,
            CustomText(text: "Please Fill The Details", fontSize: 13.sp),
            CustomText(
              text: "Anuja, when is your birthday?",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text:
                  "This helps us personalize your fitness plan based on your age.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            sh20,
            BlocBuilder<BirthdayBloc, BirthdayState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<int>(
                      value: state.birthday?.day,
                      underline: SizedBox(),
                      menuMaxHeight: 200.h,
                      hint: CustomText(text: "Day"),
                      items: List.generate(31, (index) => index + 1)
                          .map((day) =>
                              DropdownMenuItem(value: day, child: Text("$day")))
                          .toList(),
                      onChanged: (day) {
                        if (day != null) {
                          _updateBirthday(context, state, day: day);
                        }
                      },
                    ),
                    DropdownButton<int>(
                      value: state.birthday?.month,
                      underline: SizedBox(),
                      menuMaxHeight: 200.h,
                      hint: CustomText(text: "Month"),
                      items: List.generate(12, (index) => index + 1)
                          .map((month) => DropdownMenuItem(
                              value: month, child: Text("$month")))
                          .toList(),
                      onChanged: (month) {
                        if (month != null) {
                          _updateBirthday(context, state, month: month);
                        }
                      },
                    ),
                    DropdownButton<int>(
                      value: state.birthday?.year,
                      underline: SizedBox(),
                      menuMaxHeight: 200.h,
                      hint: CustomText(text: "Year"),
                      items: List.generate(
                              100, (index) => DateTime.now().year - index)
                          .map((year) => DropdownMenuItem(
                              value: year, child: Text("$year")))
                          .toList(),
                      onChanged: (year) {
                        if (year != null) {
                          _updateBirthday(context, state, year: year);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text: "Next",
                onPressed: () {
                  _validateAndProceed(context, controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBirthday(BuildContext context, BirthdayState state,
      {int? day, int? month, int? year}) {
    final newBirthday = DateTime(
      year ?? state.birthday?.year ?? DateTime.now().year,
      month ?? state.birthday?.month ?? 1,
      day ?? state.birthday?.day ?? 1,
    );
    context.read<BirthdayBloc>().add(UpdateBirthday(newBirthday));
  }

  void _validateAndProceed(BuildContext context, PageController? controller) async {
    final state = context.read<BirthdayBloc>().state;
    if (state.birthday == null) {
      _showError(context, "Please select your birthday.");
      return;
    }

    int userAge = DateTime.now().year - state.birthday!.year;
    if (DateTime.now().month < state.birthday!.month ||
        (DateTime.now().month == state.birthday!.month &&
            DateTime.now().day < state.birthday!.day)) {
      userAge--;
    }

    if (userAge < 5) {
      _showError(context, "You must be at least 5 years old to use this app.");
      return;
    }

    if (uid== null) {
      _showError(context, "User not logged in.");
      return;
    }

    // Save birthday to Firestore
    await CoachService().saveCoachBirthData(uid!, state.birthday!);

    controller?.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
