// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_bloc.dart';
// import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_event.dart';
// import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_state.dart';
// import 'package:fynxfitcoaches/theme.dart';
// import 'package:fynxfitcoaches/utils/constants.dart';
// import 'package:fynxfitcoaches/models/goals_model.dart';
// import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
//
// class GoalOption extends StatelessWidget {
//   final Goal goal;
//   String uid;
//
//   GoalOption({Key? key, required this.goal,required this.uid}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FitnessGoalBloc, FitnessGoalState>(
//       builder: (context, state) {
//         final isSelected = state.selectedGoals.contains(goal.title);
//
//         return GestureDetector(
//           onTap: () {
//             context.read<FitnessGoalBloc>().add(ToggleGoalSelection(goalTitle: goal.title, uid: uid));
//           },
//           child: Column(
//             children: [
//               Container(
//                 width: 90.w,
//                 height: 90.w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle, border: isSelected
//                     ? Border.all(color: AppThemes.darkTheme.primaryColor, width: 3) // Highlight selected
//                     : null,
//
//                   color: isSelected
//                       ? AppThemes.darkTheme.primaryColor.withOpacity(0.5)
//                       : AppThemes.darkTheme.appBarTheme.foregroundColor,
//                 ),
//                 child: ClipOval(
//                   child: goal.imageUrl.isNotEmpty
//                       ? Image.network(goal.imageUrl, fit: BoxFit.cover)
//                       : Image.asset("assets/images/welcome.png", fit: BoxFit.cover),
//                 ),
//               ),
//               sh10,
//               CustomText(
//                 text: goal.title,
//                 color: isSelected ? AppThemes.darkTheme.primaryColor : Colors.white,
//                 fontSize: 14.sp,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
