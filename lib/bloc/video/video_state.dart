
import 'package:video_player/video_player.dart';

class VideoState {
  final VideoPlayerController? controller;
  final bool isPlaying;
  final bool isInitialized;

  VideoState({
    required this.controller,
    this.isPlaying = false,
    this.isInitialized = false,
  });

  VideoState copyWith({
    VideoPlayerController? controller,
    bool? isPlaying,
    bool? isInitialized,
  }) {
    return VideoState(
      controller: controller ?? this.controller,
      isPlaying: isPlaying ?? this.isPlaying,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
