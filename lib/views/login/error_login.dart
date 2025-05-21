import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: Center(
        child: SlideTransition(
          position: slideAnimation,
          child: CustomText(
            text: "Your account is not verified by the admin.",
            color: Colors.red,
            fontSize: 16.sp,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
