import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/bottomnav/nav_cubit.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/account/account.dart';
import 'package:fynxfitcoaches/views/bmi/bmi.dart';
import 'package:fynxfitcoaches/views/home/home.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  /// Function to get userId from Firebase Authentication
  String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    String? userId = getUserId();

    /// Ensure userId is available before passing it
    final List<Widget> screens = [
      const HomeScreen(),
      BMIScreen(),
      userId != null ? AccountScreen(userId: userId) : const Center(child: CircularProgressIndicator()),
    ];

    return Scaffold(
      body: BlocBuilder<BottomNavCubit, int>(
        builder: (context, state) {
          return screens[state];
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppThemes.darkTheme.scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 2.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: AppThemes.darkTheme.appBarTheme.foregroundColor!),
              onPressed: () => context.read<BottomNavCubit>().changePage(0),
            ),
            IconButton(
              icon: Icon(Icons.calculate, color: AppThemes.darkTheme.appBarTheme.foregroundColor!),
              onPressed: () => context.read<BottomNavCubit>().changePage(1),
            ),
            IconButton(
              icon: Icon(Icons.person, color: AppThemes.darkTheme.appBarTheme.foregroundColor!),
              onPressed: () => context.read<BottomNavCubit>().changePage(2),
            ),
          ],
        ),
      ),
    );
  }
}
