abstract class ArticlesEvent {}

class UploadArticlesEvent extends ArticlesEvent {
  final String imagePath;
  final String articleTitle;
  final String ArticleDescription;

  UploadArticlesEvent( {required this.imagePath, required this.articleTitle,required this.ArticleDescription, });
}
class DeleteArticlesEvent extends ArticlesEvent {
  final String documentId;
  final String imageId;

  DeleteArticlesEvent({required this.documentId, required this.imageId});
}
class FetchCoachArticlesEvent extends ArticlesEvent {}

class UpdateArticlesEvent extends ArticlesEvent {
final String articleId;
final String imagePath;
final String articleTitle;
final String articleDescription;
UpdateArticlesEvent({
required this.articleId,
required this.imagePath,
required this.articleTitle,
required this.articleDescription,
});

@override
List<Object> get props => [articleId, imagePath, articleTitle, articleDescription];
}
class DeleteCoachArticleEvent extends ArticlesEvent {
  final String articleId;

  DeleteCoachArticleEvent(this.articleId);
}
