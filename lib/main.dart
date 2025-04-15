import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_bloc.dart';
import 'package:fynxfitcoaches/bloc/birthday/birthday_bloc.dart';
import 'package:fynxfitcoaches/bloc/bottomnav/nav_cubit.dart';
import 'package:fynxfitcoaches/bloc/call/call_bloc.dart';
import 'package:fynxfitcoaches/bloc/category/category_bloc.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_bloc.dart';
import 'package:fynxfitcoaches/bloc/chat/chat_event.dart';
import 'package:fynxfitcoaches/bloc/document/documents_bloc.dart';
import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_bloc.dart';
import 'package:fynxfitcoaches/bloc/fitnessgoals/fitness_goals_event.dart';
import 'package:fynxfitcoaches/bloc/gender/gender_selection_bloc.dart';
import 'package:fynxfitcoaches/bloc/height/height_bloc.dart';
import 'package:fynxfitcoaches/bloc/infocoach/coach_info_bloc.dart';
import 'package:fynxfitcoaches/bloc/profileimage/profileimage_bloc.dart';
import 'package:fynxfitcoaches/bloc/profileonboading/profile_onboading_cubit.dart';
import 'package:fynxfitcoaches/bloc/weight/weight_bloc.dart';
import 'package:fynxfitcoaches/bloc/workouts/workout_bloc.dart';
import 'package:fynxfitcoaches/controlers/singnal_controler.dart';
import 'package:fynxfitcoaches/resources/resources_bloc.dart';
import 'package:fynxfitcoaches/resources/resources_event.dart';
import 'package:fynxfitcoaches/views/message/user_list_chat.dart';
import 'package:fynxfitcoaches/views/splash/splash.dart';
import 'bloc/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => WorkoutBloc()),
    BlocProvider(create: (context) => ArticlesBloc()),
    BlocProvider(create: (context) => AuthBloc()),
    BlocProvider(
      create: (context) => BottomNavCubit(),
    ),
    BlocProvider(
      create: (context) => ProfileOnboardingCubit(),
    ),
    BlocProvider(
      create: (context) => GenderSelectionBloc(),
    ),
    BlocProvider(
      create: (context) => WeightBloc(),
    ),
    BlocProvider(
      create: (context) => BirthdayBloc(),
    ),
    BlocProvider(
      create: (context) => HeightBloc(),
    ),
    BlocProvider(
      create: (context) => DocumentUploadCubit(),
    ),
    BlocProvider(
      create: (context) => ProfileImageCubit(),
    ),
    BlocProvider(
      create: (context) => WorkoutBloc(),
    ),
    BlocProvider(
      create: (context) => BasicInfoBloc(),
    ),
    BlocProvider(create: (context) => CategoryBloc()..add(LoadCategories())),
    BlocProvider(
        create: (context) => FitnessGoalBloc()
          ..add(
            LoadGoals(),
          )),
    BlocProvider(
      create: (_) => CallBloc(SignalingController()),
    ),

  BlocProvider(
      create: (context) =>
          ChatBloc(FirebaseFirestore.instance, FirebaseAuth.instance)
            ..add(LoadChats()),
    ),
    BlocProvider(
      create: (context) => ResourceBloc()..add(LoadArticles()),
    ),
  ], child: const MyApp()));
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
