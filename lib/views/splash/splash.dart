import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/login/error_login.dart';
import 'package:fynxfitcoaches/views/login/login.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import '../../bloc/splash/splash_bloc.dart';
import '../../bloc/splash/splash_event.dart';
import '../../bloc/splash/splash_state.dart';
import '../../widgets/splash/base_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashBloc()..add(CheckUserStatus()), // Dispatch event
      child: Scaffold(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is UserVerified) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            } else if (state is UserNotVerified) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ErrorPage()),
              );
            } else if (state is UserNotLoggedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
          child: const BaseTextsSession(),
        ),
      ),
    );
  }
}


