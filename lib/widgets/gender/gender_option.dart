import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/gender/gender_selection_bloc.dart';
import 'package:fynxfitcoaches/bloc/gender/gender_selection_event.dart';
import 'package:fynxfitcoaches/bloc/gender/gender_selection_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

class GenderOption extends StatelessWidget {
  final String label;
  final String image;

  GenderOption({required this.label, required this.image});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenderSelectionBloc, GenderSelectionState>(
      builder: (context, state) {
        bool isSelected = state.selectedGender == label;

        return GestureDetector(
          onTap: () {
            context.read<GenderSelectionBloc>().add(SelectGender(label));
          },
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            width: 90.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.grey.withOpacity(0.5)
                  : AppThemes.darkTheme.appBarTheme.foregroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, height: 35.h, width: 35.w),
                SizedBox(height: 10),
                CustomText(
                  text: label,
                  color: AppThemes.darkTheme.dialogBackgroundColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
