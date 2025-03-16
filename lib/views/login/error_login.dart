import 'package:flutter/material.dart';
import 'package:fynxfitcoaches/theme.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Error")),
      body: const Center(
        child: Text(
          "Your account is not verified by the admin.",
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
