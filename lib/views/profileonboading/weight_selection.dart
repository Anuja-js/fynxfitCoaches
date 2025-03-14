import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/weight/weight_bloc.dart';
import 'package:fynxfitcoaches/bloc/weight/weight_event.dart';
import 'package:fynxfitcoaches/bloc/weight/weight_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/weight/weight_scale.dart';

import '../../utils/services/coache_services.dart';
import '../../widgets/customs/custom_text.dart';

class WeightScreen extends StatelessWidget {
  final PageController? controller;
  String? uid;
  WeightScreen({required this.controller, required this.uid, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sh30,
            CustomText(text: "Please Fill The Details", fontSize: 13.sp),
            CustomText(
              text: "Anuja, What Is Your Weight?",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            sh20,
            // Toggle Unit Button
            BlocBuilder<WeightBloc, WeightState>(
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
                          onTap: () =>
                              context.read<WeightBloc>().add(ToggleUnit()),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: state.isKgUnit
                                  ? AppThemes.darkTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                                child: CustomText(
                                    text: 'KG',
                                    color: state.isKgUnit
                                        ? AppThemes
                                            .darkTheme.scaffoldBackgroundColor
                                        : AppThemes.darkTheme.appBarTheme
                                            .foregroundColor!)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              context.read<WeightBloc>().add(ToggleUnit()),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: !state.isKgUnit
                                  ? AppThemes.darkTheme.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                                child: Text('LB',
                                    style: TextStyle(
                                        color: !state.isKgUnit
                                            ? AppThemes
                                            .darkTheme.scaffoldBackgroundColor
                                            : AppThemes.darkTheme.appBarTheme
                                            .foregroundColor!))),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            sh50,
            BlocBuilder<WeightBloc, WeightState>(
              builder: (context, state) {
                return WeightScaleWidget(
                  initialWeight: state.selectedWeight,
                  onWeightChanged: (weight) {
                    context
                        .read<WeightBloc>()
                        .add(UpdateWeight(weight: weight));
                  },
                  isKgUnit: state.isKgUnit,
                );
              },
            ),

           sh50,
            BlocBuilder<WeightBloc, WeightState>(
              builder: (context, state) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      CustomText(text: state.selectedWeight.toStringAsFixed(0),
                              fontSize: 70,
                              fontWeight: FontWeight.bold),
                     sw5,
                      CustomText(text: state.isKgUnit ? 'kg' : 'lb',fontSize: 24),
                    ],
                  ),
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
                onPressed: () async{
                  final state = context.read<WeightBloc>().state;
                  if (uid != null) {
                    await CoachService().saveCoachWeightData(uid!, state.selectedWeight, state.isKgUnit);
                  }
                  controller?.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
