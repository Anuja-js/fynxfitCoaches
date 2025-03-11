import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color splashColor;
  final EdgeInsets padding;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.blue,
    this.splashColor = Colors.transparent,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: splashColor,
        padding: padding,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );
  }
}
