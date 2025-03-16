import 'package:fynxfitcoaches/models/article_model.dart';

abstract class ArticlesState {}

class ArticlesInitial extends ArticlesState {}
class ArticlesLoading extends ArticlesState {}
// class ArticlesSuccess extends ArticlesState {}
class ArticlesDelete extends ArticlesState {}

class ArticlesLoaded extends ArticlesState {
  final List<Map<String, dynamic>> articles;

  ArticlesLoaded(this.articles);
}
class ArticlesSuccess extends ArticlesState {
  final List<ArticleModel> articles;
  ArticlesSuccess(this.articles);
}

class ArticlesFailure extends ArticlesState {
  final String error;
  ArticlesFailure(this.error);
}


