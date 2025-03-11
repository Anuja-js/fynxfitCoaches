import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color textColor;
  final Color fillColor;
  final Color hintColor;
  final Color borderColor;
  final Color errorborderColor;
  final Color focusedBorderColor;
  final Color cursorColor;
  final double fontSize;
  final TextOverflow overflow;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textColor = Colors.black,
    this.fillColor = Colors.white,
    this.hintColor = Colors.grey,
    this.borderColor = Colors.grey,
    this.errorborderColor = Colors.red,
    this.focusedBorderColor =Colors.grey,
    this.cursorColor = Colors.black,
    this.fontSize = 14.0,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      textAlign: textAlign,
      textInputAction: textInputAction,
      validator: validator,
      cursorColor: cursorColor,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize.sp,
        overflow: overflow,
      ),
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: fontSize.sp),
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: '',
        errorBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: errorborderColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
