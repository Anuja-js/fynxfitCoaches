import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/height/height_bloc.dart';
import 'package:fynxfitcoaches/bloc/height/height_event.dart';
import 'package:fynxfitcoaches/bloc/height/height_state.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/widgets/height/height_scale.dart';
import '../../../theme.dart';
import '../../../widgets/customs/custom_elevated_button.dart';
import '../../../widgets/customs/custom_text.dart';
import '../../utils/services/coache_services.dart';

class HeightScreen extends StatelessWidget {
  final PageController? controller;
  String?uid;
HeightScreen({required this.controller,required this .uid,Key? key}) : super(key: key);

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
              text: "Anuja, What Is Your Height?",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Help us customize your fitness plan by selecting your height.",
              fontSize: 10.sp,
              overflow: TextOverflow.visible,
              color: AppThemes.darkTheme.dividerColor,
            ),
            SizedBox(height: 20.h),

            // Unit Toggle Button
            BlocBuilder<HeightBloc, HeightState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppThemes.darkTheme.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  height: 50.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<HeightBloc>().add(ToggleUnit()),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: state.isCmUnit ? AppThemes.darkTheme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Text(
                              'CM',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: state.isCmUnit ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<HeightBloc>().add(ToggleUnit()),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !state.isCmUnit ? AppThemes.darkTheme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Text(
                              'IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !state.isCmUnit ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 40.h),

            // Height Scale
            BlocBuilder<HeightBloc, HeightState>(
              builder: (context, state) {
                return HeightScaleWidget(
                  initialHeight: state.selectedHeight,
                  onHeightChanged: (height) {
                    context.read<HeightBloc>().add(UpdateHeight(height));
                  },
                  isCmUnit: state.isCmUnit,
                );
              },
            ),
            SizedBox(height: 40.h),

            // Height Display
            BlocBuilder<HeightBloc, HeightState>(
              builder: (context, state) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        state.selectedHeight.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        state.isCmUnit ? 'cm' : 'in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Spacer(),

            // Next Button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text: "Next",
                onPressed: () async{
                  final state = context.read<HeightBloc>().state;
                  if (uid != null) {
                    await CoachService().saveCoachHeightData(uid!, state.selectedHeight, state.isCmUnit);
                  }
                  controller?.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
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

