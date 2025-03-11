import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double elevation;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    this.elevation = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
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
