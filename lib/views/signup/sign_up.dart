import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_event.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/main_page/main_screen.dart';
import 'package:fynxfitcoaches/views/profileonboading/profile_onboading_main.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_images.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_form_field.dart';
import 'package:fynxfitcoaches/widgets/signup/login_widget.dart';
import '../login/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
            const CustomImages(image: "assets/images/login.png"),
            SizedBox(height: 50.h),
            CustomText(
              text: "Join Us Today!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            const CustomText(
              text: "Create Your Account",
              color: Color(0xff6D6D6D),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthSuccess) {
                    String userId = state.user.uid;

                    // 🔹 Check Firestore if onboarding is complete
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get();

                    bool isOnboardingComplete = userDoc.exists && (userDoc['profileOnboarding'] ?? false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Sign Up Successful!")),
                    );

                    // 🔹 Navigate based on onboarding status
                    if (isOnboardingComplete) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()), // Main dashboard
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileOnboadingMain(userId: userId)),
                      );
                    }
                  }
                  else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },builder:  (context, state) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: "Enter Your Email",
                          textColor:
                              AppThemes.darkTheme.scaffoldBackgroundColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          hintText: "Enter Your Password",
                          textColor:
                              AppThemes.darkTheme.scaffoldBackgroundColor,
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
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.text,
                          hintText: "Confirm Your Password",
                          textColor:
                              AppThemes.darkTheme.scaffoldBackgroundColor,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        sh20,
                        if (state is AuthLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CustomElevatedButton(
                              backgroundColor: AppThemes.darkTheme.primaryColor,
                              textColor:
                                  AppThemes.darkTheme.scaffoldBackgroundColor,
                              text: "Sign Up",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(SignUpEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ));


                                }
                              },
                            ),
                          ),
                        sh10,
                        LoginWidget(
                          ontap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          richtext2: " login",
                          richtext1: "Already have an account?",
                        ),
                        SizedBox(height: 20.h),
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
