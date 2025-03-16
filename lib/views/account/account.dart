import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/workouts/workout_list.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import '../articles/article_list.dart';

class AccountScreen extends StatelessWidget {
  final String userId;

  AccountScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: "Account",
          fontSize: 18.sp,
        ),
        elevation: 0,
      ),
      body: Column(
              children: [

                SizedBox(height: 10.h),
                CustomListTileAccount(
                  leading: CustomText(
                    text: "My Workout",
                    fontSize: 15.sp,
                  ),
                  ontap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return WorkoutListPage();
                    }));
                  },
                ),
                CustomListTileAccount(
                  leading: CustomText(
                    text: "My Articles",
                    fontSize: 15.sp,
                  ),
                  ontap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return ArticleListPage();
                    }));
                  },
                ),
              ],
            ));
  }}


class CustomListTileAccount extends StatelessWidget {
  GestureTapCallback ontap;
  Widget leading;
CustomListTileAccount({
    super.key,required this.ontap,required this.leading
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:ontap,
      leading:leading,
      trailing: Icon(Icons.arrow_forward_ios_outlined,size: 15,color: AppThemes.darkTheme.appBarTheme.foregroundColor!,),
    );
  }
}
