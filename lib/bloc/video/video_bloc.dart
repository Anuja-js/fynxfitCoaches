import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/video/video_event.dart';
import 'package:fynxfitcoaches/bloc/video/video_state.dart';
import 'package:video_player/video_player.dart';


class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState(controller: null)) {
    on<LoadVideo>((event, emit) async {
      final controller = VideoPlayerController.network(event.videoUrl);
      await controller.initialize();
      emit(state.copyWith(controller: controller, isInitialized: true));
    });

    on<PlayPauseVideo>((event, emit) {
      if (state.controller != null) {
        if (state.isPlaying) {
          state.controller!.pause();
        } else {
          state.controller!.play();
        }
        emit(state.copyWith(isPlaying: !state.isPlaying));
      }
    });
  }

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }
}
