
abstract class VideoEvent {}

class LoadVideo extends VideoEvent {
  final String videoUrl;
  LoadVideo(this.videoUrl);
}

class PlayPauseVideo extends VideoEvent {}
