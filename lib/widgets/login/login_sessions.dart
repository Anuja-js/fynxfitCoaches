import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../theme.dart';
import '../../views/login/error_login.dart';
import '../../views/main_page/main_screen.dart';
import '../customs/custom_elevated_button.dart';

class LoginSession extends StatelessWidget {
  const LoginSession({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomElevatedButton(
          backgroundColor: AppThemes.darkTheme.primaryColor,
          textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
          text: "Login",
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final authBloc = context.read<AuthBloc>();
              authBloc.add(
                  LoginEvent(emailController.text, passwordController.text));

              // Listen for the AuthSuccess state
              authBloc.stream.listen((state) async {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Successful!")),
                  );

                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('coaches')
                        .doc(user.uid)
                        .get();

                    if (userDoc.exists) {
                      bool isProfileOnboarded =
                          userDoc['profileOnboarding'] ?? false;

                      if (isProfileOnboarded) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => const MainPage()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const ErrorPage()),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("User data not found. Contact support.")),
                      );
                    }
                  }
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              });
            }
          }),
    );
  }
}
