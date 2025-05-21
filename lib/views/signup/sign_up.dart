
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_images.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

import '../../widgets/signup/textfields_button_session.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomImages(image: "assets/images/login.png"),
            sh50,
            CustomText(
              text: "Join Us Today!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: "Create Your Account",
              color: Color(0xff6D6D6D),
            ),
            TextFieldsSessionAndButton(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController),
          ],
        ),
      ),
    );
  }
}


