import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/video/video_event.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:video_player/video_player.dart';
import '../../bloc/video/video_bloc.dart';
import '../../bloc/video/video_state.dart';
import '../../utils/constants.dart';
import '../../widgets/customs/custom_text.dart';

class WorkoutDetailPage extends StatelessWidget {
  final String videoUrl;
  final String description;

  const WorkoutDetailPage(
      {super.key, required this.videoUrl, required this.description});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc()..add(LoadVideo(videoUrl)),
      child: Scaffold(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: CustomText(
            text: "Workout Video",
            fontSize: 18.sp,
          ),
          elevation: 0,
        ),
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (!state.isInitialized) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 12.sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.4,
                      child: AspectRatio(
                        aspectRatio: state.controller!.value.aspectRatio,
                        child: VideoPlayer(state.controller!),
                      ),
                    ),
                    sh10,
                    CustomText(
                      text: description,
                      overflow: TextOverflow.visible,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<VideoBloc>().add(PlayPauseVideo());
                      },
                      child: Icon(
                        color: AppThemes.darkTheme.primaryColor,
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
