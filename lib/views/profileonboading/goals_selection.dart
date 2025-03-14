// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_bloc.dart';
// import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_event.dart';
// import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_state.dart';
// import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
// import 'package:fynxfitcoaches/widgets/goals/goals_option.dart';
// import '../../../theme.dart';
// import '../../../widgets/customs/custom_elevated_button.dart';
//
// class ProfilePictureSelection extends StatelessWidget {
//   final PageController? controller;
//   final String uid; // User ID for Firestore storage
//
//   ProfilePictureSelection({required this.controller, required this.uid, Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
//       body: Padding(
//         padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 30.h),
//             CustomText(text: "What’s Your Fitness Goal?", fontSize: 13.sp),
//             CustomText(
//               text: "Personalize Your Fitness Journey\nwith Us!",
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//             CustomText(
//               text: "Choose your goals so we can tailor your\nworkout and nutrition plan to fit your needs.",
//               fontSize: 10.sp,
//               color: AppThemes.darkTheme.dividerColor,
//             ),
//             SizedBox(height: 20.h),
//
//             BlocBuilder<FitnessGoalBloc, FitnessGoalState>(
//               builder: (context, state) {
//                 if (state.isLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (state.error != null) {
//                   return Center(
//                     child: CustomText(
//                       text: state.error!,
//                       color: Colors.red,
//                       fontSize: 14.sp,
//                     ),
//                   );
//                 }
//                 return Wrap(
//                   spacing: 12.w,
//                   runSpacing: 12.h,crossAxisAlignment:WrapCrossAlignment.center,
//                   alignment: WrapAlignment.center,
//                   children: state.goals
//                       .map((goal) => GoalOption(goal: goal, uid: uid))
//                       .toList(),
//                 );
//               },
//             ),
//
//             Spacer(),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: BlocBuilder<FitnessGoalBloc, FitnessGoalState>(
//                 builder: (context, state) {
//                   return CustomElevatedButton(
//                     backgroundColor: AppThemes.darkTheme.primaryColor,
//                     textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
//                     text: "Next",
//                     onPressed: () {
//                       if (state.selectedGoals.isNotEmpty) {
//                         context.read<FitnessGoalBloc>().add(SaveSelectedGoals(uid: uid));
//
//                         // Delay navigation to ensure Firestore updates
//                         Future.delayed(Duration(milliseconds: 500), () {
//                           controller?.nextPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                         });
//
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: CustomText(
//                               text: "Please select at least one fitness goal",
//                               color: AppThemes.darkTheme.scaffoldBackgroundColor,
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
