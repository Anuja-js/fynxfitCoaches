import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_bloc.dart';
import 'package:fynxfitcoaches/bloc/bottomnav/nav_cubit.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_bloc.dart';
import 'package:fynxfitcoaches/views/splash/splash.dart';
import 'bloc/auth/auth_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WorkoutBloc()),
        BlocProvider(create: (context) => ArticlesBloc()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => BottomNavCubit(),),
      ],child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: child,
          );
      },
      child: const SplashScreen(),
    );
  }
}
