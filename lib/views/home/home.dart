import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_bloc.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_event.dart';
import 'package:fynxfitcoaches/bloc/auth/auth_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/views/articles/articles.dart';
import 'package:fynxfitcoaches/views/login/login.dart';
import 'package:fynxfitcoaches/views/workouts/wokout.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) {
              return LoginScreen();
            }));
          }
        },
        child: Scaffold(
          backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
          body: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMainCategories(),
                      buildRecommendationSection(),
                      buildResourcesSection(),
                      buildWeeklyChallenge(),
                      buildCreateWorkouts(context),
                      buildCreateArticles(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // _buildBottomNavigation(),
            ],
          ),
        ));
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppThemes.darkTheme.primaryColor,
        gradient: LinearGradient(
          colors: [
            Colors.black,
            AppThemes.darkTheme.primaryColor
          ], // Subtle gradient effect
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width / 1.5,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppThemes.darkTheme.dividerColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: CustomTextField(
                  border: InputBorder.none,
                  textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                  hintText: 'Search for Workouts, Diet Plans...',
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: AppThemes.darkTheme.scaffoldBackgroundColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, size: 20),
                onPressed: () {},
                tooltip: 'Notifications',
                color: AppThemes.darkTheme.scaffoldBackgroundColor,
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 20),
                onPressed: () {

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                    context.read<AuthBloc>().add(LogoutEvent());
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                ); // Navigate to LoginScreen
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        );
                      },
                    );

                },
                tooltip: 'Logout',
                color: AppThemes.darkTheme.scaffoldBackgroundColor,
              ),
            ],
          ),
          sh20,
          CustomText(
            text: "It's time to challenge your limits.",
          ),
        ],
      ),
    );
  }


  Widget buildMainCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildCategoryItem(Icons.fitness_center, 'Workout', Colors.purple.shade300),
          sw10,
        CustomText(text: '||',fontSize: 15.sp,),
         sw10,
          buildCategoryItem(Icons.apple, 'Nutrition', Colors.white),
        ],
      ),
    );
  }

  Widget buildCategoryItem(IconData icon, String label, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
      sh10,
        Text(label, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }

  Widget buildRecommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomText(text:
             'Recommendations',

               fontSize: 18,
               fontWeight: FontWeight.bold,
               ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              buildWorkoutCard(
                'Squat Exercise',
                'Beginner Guide',
                '24 Minutes',
                '100 kcal',
                'assets/images/welcome.png',
              ),
              sw10,
              buildWorkoutCard(
                'Full Body Stretches',
                'Quick & Effective Guide',
                '12 Minutes',
                '90 kcal',
                'assets/images/welcome.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildWorkoutCard(String title, String subtitle, String duration, String calories, String imagePath) {
    return Container(
      width: 150.w,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade900,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                imagePath,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 8,
                bottom: 1,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
                ),
              ),
              Positioned(
                left: 1,
               top: 1,
                child: IconButton(onPressed: (){}, icon: Icon(Icons.star,color: Colors.yellow,))
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text:
                  title,
                    fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CustomText(text:
                  subtitle,
                    fontSize: 12,
                    color:AppThemes.darkTheme.dividerColor,

                ),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.timer, size: 12, color:AppThemes.darkTheme.dividerColor),
                    const SizedBox(width: 4),
                    CustomText(text:
                      duration,

                        fontSize: 10,
                        color:AppThemes.darkTheme.dividerColor,

                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.local_fire_department, size: 12, color:AppThemes.darkTheme.dividerColor),
                    const SizedBox(width: 4),
                    Text(
                      calories,
                      style: TextStyle(
                        fontSize: 10,
                        color:AppThemes.darkTheme.dividerColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text:
                'Resources',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,

              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children:  [
                    CustomText(text: 'See All',color: AppThemes.darkTheme.appBarTheme.foregroundColor!,),
                    Icon(Icons.chevron_right, size: 16,color: AppThemes.darkTheme.appBarTheme.foregroundColor,),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              buildResourceCard('assets/images/welcome.png'),
              const SizedBox(width: 16),
              buildResourceCard('assets/images/welcome.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildResourceCard(String imagePath) {
    return Container(
      width: 160,
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildMenuOption(String title,) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomText(text:
              title,

                fontSize: 16,
                fontWeight: FontWeight.w500,

            ),
          ),
          Icon(Icons.chevron_right, size: 20,color: AppThemes.darkTheme.appBarTheme.foregroundColor,),
        ],
      ),
    );
  }

  Widget buildWeeklyChallenge() {
    return InkWell(
      onTap: () {},
      child: buildMenuOption('Create Weekly Challenge' ),
    );
  }

  Widget buildCreateWorkouts(context) {
    return InkWell(
      onTap: () {
     Navigator.push(context,MaterialPageRoute(builder: (ctx){
       return WorkoutAddPage();
     }));
      },
      child: buildMenuOption('Create Workouts',),
    );
  }

  Widget buildCreateArticles(context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (ctx){
          return ArticleUploadPage();
        }));
      },
      child: buildMenuOption('Create Articles', ),
    );
  }

}
