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
import 'package:fynxfitcoaches/views/home/home.dart';
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


                    // Fetch the currently signed-in user
                    User? user = await FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Fetch user details from Firestore
                      DocumentSnapshot userDoc = await FirebaseFirestore.instance
                          .collection('coaches') // Change to your Firestore collection
                          .doc(user.uid)
                          .get();

                      if (userDoc.exists) {
                        String? verified = userDoc['verified'].toString(); // Ensure 'verified' field exists

                        if (verified == "true") {
                          // Navigate to the main page if verified
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (ctx) => MainPage()),
                          );
                        } else {
                          // Navigate to an error page if not verified
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (ctx) => ErrorPage()), // Replace with your error page
                          );
                        }
                      } else {
                        // Handle case where the user document does not exist
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User data not found. Contact support.")),
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
                        CustomTextFormField(
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
                        ),
                        const SizedBox(height: 10),
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: CustomElevatedButton(
                              backgroundColor: AppThemes.darkTheme.primaryColor,
                              textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                              text: "Login",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(LoginEvent(
                                    _emailController.text,
                                    _passwordController.text,
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
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          richtext2: " Sign Up",
                          richtext1: "Don't have an account?",
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
