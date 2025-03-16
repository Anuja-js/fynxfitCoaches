abstract class ResourceState {}

class ResourceInitial extends ResourceState {}

class ResourceLoading extends ResourceState {}

class WorkoutVideosLoaded extends ResourceState {
  final List<Map<String, dynamic>> workouts;
  WorkoutVideosLoaded({required this.workouts});
}

class ArticlesLoaded extends ResourceState {
  final List<Map<String, dynamic>> articles;
  ArticlesLoaded({required this.articles});
}

class ResourceError extends ResourceState {
  final String message;
  ResourceError({required this.message});
}
