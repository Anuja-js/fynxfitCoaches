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
