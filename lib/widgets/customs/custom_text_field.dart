import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color textColor;
  final double fontSize;
  final TextOverflow overflow;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final InputBorder border;
  final bool enabled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textColor = Colors.white,
    this.fontSize = 12.0,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    this.maxLength,
    this.minLines=1,
    this.prefixIcon,
    this.suffixIcon,
    this.border = const OutlineInputBorder(),
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      enabled: enabled,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize.sp,
        overflow: overflow,
      ),
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: textColor, fontSize: fontSize.sp),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border,
        counterText: '',
      ),
    );
  }
}
