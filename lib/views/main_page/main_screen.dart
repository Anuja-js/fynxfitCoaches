import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/bottomnav/nav_cubit.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/account/account.dart';
import 'package:fynxfitcoaches/views/bmi/bmi.dart';
import 'package:fynxfitcoaches/views/home/home.dart';

class MainPage extends StatelessWidget {
  final List<Widget> screens = [
    const HomeScreen(),
    BMIScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.home),
              onPressed: () => context.read<BottomNavCubit>().changePage(0),
            ),
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () => context.read<BottomNavCubit>().changePage(1),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.read<BottomNavCubit>().changePage(2),
            ),
          ],
        ),
      ),
    );
  }
}
