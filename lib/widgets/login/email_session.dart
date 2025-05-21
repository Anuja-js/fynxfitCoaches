import 'package:flutter/material.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_form_field.dart';
class EmailSession extends StatelessWidget {
  const EmailSession({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      hintText: "Enter Your Email",
      textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      },
    );
  }
}