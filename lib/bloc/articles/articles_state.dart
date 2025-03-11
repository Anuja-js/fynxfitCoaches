abstract class ArticlesState {}

class ArticlesInitial extends ArticlesState {}
class ArticlesLoading extends ArticlesState {}
class ArticlesSuccess extends ArticlesState {}
class ArticlesDelete extends ArticlesState {}
class ArticlesFailure extends ArticlesState {
  final String error;
  ArticlesFailure(this.error);
}
