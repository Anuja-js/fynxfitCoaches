import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_event.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/profileonboading/profile_onboading_main.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_form_field.dart';
import 'package:fynxfitcoaches/widgets/signup/login_widget.dart';
import '../../bloc/password_cubit.dart';
import '../../views/login/login.dart';
class TextFieldsSessionAndButton extends StatelessWidget {
  const TextFieldsSessionAndButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
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

            bool isOnboardingComplete =
                userDoc.exists && (userDoc['profileOnboarding'] ?? false);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sign Up Successful!")),
            );

            // 🔹 Navigate based on onboarding status
            if (isOnboardingComplete) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()), // Main dashboard
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileOnboadingMain(userId: userId)),
              );
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
              children: [
                CustomTextFormField(
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
                ),
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
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    );
                  },
                ),
                sh10,
                CustomTextFormField(
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.text,
                  hintText: "Confirm Your Password",
                  textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != passwordController.text) {
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
                      textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                      text: "Sign Up",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(SignUpEvent(
                            email: emailController.text,
                            password: passwordController.text,
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
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  richtext2: " login",
                  richtext1: "Already have an account?",
                ),
                sh20,
              ],
            ),
          );
        },
      ),
    );
  }
}