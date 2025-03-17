import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/login/error_login.dart';
import 'package:fynxfitcoaches/views/login/login.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_splash_icon.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import '../../bloc/splash/splash_bloc.dart';
import '../../bloc/splash/splash_event.dart';
import '../../bloc/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(CheckUserStatus()), // Dispatch event
      child: Scaffold(backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {

            if (state is UserVerified) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            } else if (state is UserNotVerified) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ErrorPage()),
              );
            }  else if (state is UserNotLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Expanded(child: Center(child: IconSplashImage())),
                CustomText(
                  text: "Trainer Hub",
                  color: AppThemes.darkTheme.appBarTheme.foregroundColor!,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  textAlign: TextAlign.center,
                ), CustomText(
                  text: "EAT. SLEEP. WORKOUT",
                  color: AppThemes.darkTheme.primaryColor,
                  fontSize: 15.sp,
                  textAlign: TextAlign.center,
                ),
                CustomText(
                  text: "Powered by Passion",
                  color: AppThemes.darkTheme.primaryColor,
                  fontSize: 10.sp,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
