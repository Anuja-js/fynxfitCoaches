import 'package:flutter/material.dart';
import 'package:fynxfitcoaches/views/signup/sign_up.dart';
import 'package:fynxfitcoaches/widgets/signup/login_widget.dart';

class SignUpSession extends StatelessWidget {
  const SignUpSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoginWidget(
      ontap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      },
      richtext2: " Sign Up",
      richtext1: "Don't have an account?",
    );
  }
}
