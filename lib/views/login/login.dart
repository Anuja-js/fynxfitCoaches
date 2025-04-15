import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_event.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/login/error_login.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import 'package:fynxfitcoaches/views/signup/sign_up.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_images.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_form_field.dart';
import 'package:fynxfitcoaches/widgets/signup/login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomImages(image: "assets/images/welcome.png"),
            SizedBox(height: 50.h),
            CustomText(
              text: "Welcome Back!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: "Login to Your Account",
              color: Color(0xff6D6D6D),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Successful!")),
                    );
                    User? user = await FirebaseAuth.instance.currentUser;

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
                            MaterialPageRoute(builder: (ctx) => MainPage()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (ctx) => const ErrorPage()),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User data not found. Contact support.")),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EmailSession(emailController: _emailController),
                        sh10,
                        CustomTextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          hintText: "Enter Your Password",
                          textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        sh20,
                        if (state is AuthLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          LoginSession(formKey: formKey, emailController: _emailController, passwordController: _passwordController),
                        sh10,
                        const SignUpSession(),
                       sh20,
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailSession extends StatelessWidget {
  const EmailSession({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: _emailController,
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

class LoginSession extends StatelessWidget {
  const LoginSession({
    super.key,
    required this.formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) : _emailController = emailController, _passwordController = passwordController;

  final GlobalKey<FormState> formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

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
              authBloc.add(LoginEvent(_emailController.text, _passwordController.text));

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
                      bool isProfileOnboarded = userDoc['profileOnboarding'] ?? false;

                      if (isProfileOnboarded) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => MainPage()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => const ErrorPage()),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User data not found. Contact support.")),
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
          }

        // onPressed: () {
        //   if (formKey.currentState!.validate()) {
        //
        //     context.read<AuthBloc>().add(LoginEvent(
        //       _emailController.text,
        //       _passwordController.text,
        //     ));
        //   }
        // },
      ),
    );
  }
}

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
          MaterialPageRoute(
              builder: (context) => const SignUpScreen()),
        );
      },
      richtext2: " Sign Up",
      richtext1: "Don't have an account?",
    );
  }
}
