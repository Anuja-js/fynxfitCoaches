import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/profileonboading/profile_onboading_cubit.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/profileonboading/basic_info.dart';
import 'package:fynxfitcoaches/views/profileonboading/birthday_date.dart';
import 'package:fynxfitcoaches/views/profileonboading/document.dart';
import 'package:fynxfitcoaches/views/profileonboading/gender_selection.dart';
import 'package:fynxfitcoaches/views/profileonboading/goals_selection.dart';
import 'package:fynxfitcoaches/views/profileonboading/height_selection.dart';
import 'package:fynxfitcoaches/views/profileonboading/profile_image_selection.dart';
import 'package:fynxfitcoaches/views/profileonboading/weight_selection.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileOnboadingMain extends StatefulWidget {
  final String userId;

  ProfileOnboadingMain({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileOnboadingMain> createState() => _ProfileOnboadingMainState();
}

class _ProfileOnboadingMainState extends State<ProfileOnboadingMain> {
  PageController pagecntroller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      ),
      body: Stack(
        children: [
          PageView(
            controller: pagecntroller,
            physics: ScrollPhysics(),
            children: [
              GenderSelectionScreen(userId: widget.userId, controller: pagecntroller),
              BasicInformationScreen(controller: pagecntroller, uid: widget.userId),
              BirthdayScreen(controller: pagecntroller, uid:widget.userId,),
              WeightScreen(controller: pagecntroller, uid:widget.userId),
              HeightScreen(controller: pagecntroller,uid: widget.userId,),
              DocumentUploadScreen(controller: pagecntroller,uid: widget.userId,), 
              ProfileImageScreen(controller: pagecntroller,uid: widget.userId,),
            ],
          ),
          Positioned(
            top: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: pagecntroller,
                count: 7,
                effect: WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.purple,
                  dotWidth: 45.w,
                  dotHeight: 8.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
