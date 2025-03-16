import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/resources/resources_bloc.dart';
import 'package:fynxfitcoaches/resources/resources_event.dart';
import 'package:fynxfitcoaches/resources/resources_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/views/resources_page/workout_details.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

import 'article_details.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,automaticallyImplyLeading: false,
          title: CustomText(text:"Resources",fontSize: 18.sp,),elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Articles"),
              Tab(text: "Workout Videos"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ArticlesTab(),
            WorkoutVideosTab(),
          ],
        ),
      ),
    );
  }
}
class ArticlesTab extends StatelessWidget {
  const ArticlesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResourceBloc, ResourceState>(
      builder: (context, state) {
        if (state is ResourceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ArticlesLoaded) {
          return ListView.builder(
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              var article = state.articles[index];
              return ArticleCard (
                title: article["title"],
                subtitle: article["subtitle"],
                imageUrl: article["imageUrl"]
              );
            },
          );
        } else if (state is ResourceError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
class WorkoutVideosTab extends StatelessWidget {
  const WorkoutVideosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResourceBloc()..add(LoadWorkoutVideos()),
      child: BlocBuilder<ResourceBloc, ResourceState>(
        builder: (context, state) {
          if (state is ResourceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutVideosLoaded) {
            return ListView.builder(
              itemCount: state.workouts.length,
              itemBuilder: (context, index) {
                var workout = state.workouts[index];
                return WorkoutCard(

                  title: workout["title"],
                  videoUrl:  workout["videoUrl"],
                  description: workout["subtitle"],
                );
              },
            );
          } else if (state is ResourceError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}




class ArticleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const ArticleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(
              title: title,
              subtitle: subtitle,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        child: Column(
          children: [
            Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            ListTile(
              title: CustomText(text: title, fontWeight: FontWeight.bold,color: AppThemes.darkTheme.scaffoldBackgroundColor,fontSize: 13,),
              subtitle: CustomText(text: subtitle, maxLines: 2,color: AppThemes.darkTheme.scaffoldBackgroundColor,),
              trailing: Icon(Icons.arrow_forward_ios, color: AppThemes.darkTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String videoUrl;
  final String description;

  const WorkoutCard({super.key, required this.title, required this.videoUrl,required this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(videoUrl: videoUrl,description:description),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4,
        child: ListTile(
          title: CustomText(text: title,color: AppThemes.darkTheme.scaffoldBackgroundColor,fontWeight: FontWeight.bold,),
          trailing: Icon(Icons.play_circle_fill, color: AppThemes.darkTheme.primaryColor),
        ),
      ),
    );
  }
}
