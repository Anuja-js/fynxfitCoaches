
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

import '../../theme.dart';
import '../customs/custom_splash_icon.dart';

class BaseTextsSession extends StatelessWidget {
  const BaseTextsSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          ),
          CustomText(
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
    );
  }
}