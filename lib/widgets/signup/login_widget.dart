import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/theme.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({
    super.key,required this.ontap,required this.richtext1,required this.richtext2,
  });
final GestureTapCallback ontap;
String richtext1;
String richtext2;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:richtext1,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppThemes
                    .darkTheme.appBarTheme.foregroundColor, // Title in white
              ),
            ),
            TextSpan(
              text: richtext2,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppThemes.darkTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}