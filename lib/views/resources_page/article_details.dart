import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const ArticleDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: title,
          fontSize: 18.sp,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
              child: CustomText(
                text: subtitle,
                fontSize: 12.sp,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
