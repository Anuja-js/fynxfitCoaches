import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/profileimage/profileimage_bloc.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/login/login.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

class ProfileImageScreen extends StatelessWidget {
  final PageController controller;
  final String uid;

  ProfileImageScreen({Key? key, required this.controller, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: BlocBuilder<ProfileImageCubit, ProfileImageState>(
        builder: (context, state) {
          final cubit = context.read<ProfileImageCubit>();

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh30,
                CustomText(
                  text: "Upload Your Profile Picture",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                sh10,
                CustomText(
                  text: "A clear picture helps users recognize you better.",
                  fontSize: 13.sp,
                ),
                sh10,
                CustomText(
                  text: "Ensure your profile picture is clear and in the correct format.",
                  fontSize: 10.sp,
                  overflow: TextOverflow.visible,
                  color: AppThemes.darkTheme.dividerColor,
                ),
                CustomText(
                  text: "Accepted formats: PNG, JPG",
                  fontSize: 10.sp,
                  color: AppThemes.darkTheme.primaryColor,
                ),
                sh10,
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80.w,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: state.imageprofile != null ? FileImage(state.imageprofile!) : null,
                        child: state.imageprofile== null
                            ? Icon(Icons.person, size: 80.w, color: Colors.grey[600])
                            : null,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => cubit.pickImage(),
                          child: CircleAvatar(
                            radius: 22.w,
                            backgroundColor: AppThemes.darkTheme.primaryColor,
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 22.w),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sh20,
                if (state.isLoadingprofile)
                  Center(child: CircularProgressIndicator()),
                if (state.imageprofile != null)
         Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width ,
                        child: CustomElevatedButton(
                          backgroundColor: AppThemes.darkTheme.primaryColor,
                          textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                          text: "Upload & Continue",
                          onPressed: () {
                            cubit.uploadToCloudinary(state.imageprofile!, uid);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                              return LoginScreen();
                            }));
                          },
                        ),

                  ),
                if (state.errorprofile != null)
                  Center(
                    child: Text(
                      state.errorprofile!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
