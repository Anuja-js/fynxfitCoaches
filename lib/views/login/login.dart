import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/login/error_login.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_images.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_form_field.dart';
import '../../bloc/password_cubit.dart';
import '../../widgets/login/email_session.dart';
import '../../widgets/login/login_sessions.dart';
import '../../widgets/login/signup_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomImages(image: "assets/images/welcome.png"),
            sh50,
            CustomText(
              text: "Welcome Back!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: "Login to Your Account",
              color: Color(0xff6D6D6D),
            ),
            TextFieldSession()
          ],
        ),
      ),
    );
  }
}

Widget TextFieldSession() {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return Padding(
    padding: const EdgeInsets.all(15),
    child: BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
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
              String? verified = userDoc['verified'].toString();
              if (verified == "true") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (ctx) => const MainPage()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (ctx) => const ErrorPage()),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("User data not found. Contact support.")),
              );
            }
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              EmailSession(emailController: emailController),
              sh10,
              BlocBuilder<PasswordVisibilityCubit, bool>(
                builder: (context, isPasswordVisible) {
                  return CustomTextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    hintText: "Enter Your Password",
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                    obscureText: !isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        context
                            .read<PasswordVisibilityCubit>()
                            .toggleVisibility();
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  );
                },
              ),
              sh20,
              if (state is AuthLoading)
                const CircularProgressIndicator()
              else
                LoginSession(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController),
              sh10,
              const SignUpSession(),
              sh20,
            ],
          ),
        );
      },
    ),
  );
}
