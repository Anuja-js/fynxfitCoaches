import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/bottomnav/nav_cubit.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/account/account.dart';
import 'package:fynxfitcoaches/views/bmi/bmi.dart';
import 'package:fynxfitcoaches/views/home/home.dart';
import 'package:fynxfitcoaches/views/message/user_list_chat.dart';

import '../../bloc/bmi/bmi_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
@override
  void initState() {
requestPermission();
    super.initState();
    getToken();
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("Foreground Message: ${message.notification?.title}");
  // You can show a custom dialog or snackbar here
});

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print("App opened from background: ${message.notification?.title}");
  // Navigate to a specific screen, e.g. workout screen
});
  }
  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    await FirebaseFirestore.instance.collection('coaches').doc(FirebaseAuth.instance.currentUser!.uid).set({
      "fcmtocken":token
    }, SetOptions(merge: true));

  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {

    String? userId = getUserId();
    final List<Widget> screens = [
      const HomeScreen(),
      BlocProvider(
        create: (_) => BmiBloc(),
        child: BmiScreen(),
      ),
     CoachChatListScreen(),
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
              icon: Icon(Icons.chat, color: AppThemes.darkTheme.appBarTheme.foregroundColor!),
              onPressed: () => context.read<BottomNavCubit>().changePage(2)
            ),
            IconButton(
              icon: Icon(Icons.person, color: AppThemes.darkTheme.appBarTheme.foregroundColor!),
              onPressed: () => context.read<BottomNavCubit>().changePage(3),
            ),
          ],
        ),
      ),
    );
  }
}
