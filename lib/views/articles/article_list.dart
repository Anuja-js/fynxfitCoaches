import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_bloc.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_event.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

import 'edit_article.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  _ArticleListPageState createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesBloc>().add(FetchCoachArticlesEvent());
  }

  void _confirmDelete(BuildContext context, String articleId,String docId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Article"),
        content: const Text("Are you sure you want to delete this article?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<ArticlesBloc>().add(DeleteArticlesEvent(imageId: articleId,documentId:docId ));
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const CustomText(
          text: "Articles",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppThemes.darkTheme.appBarTheme.backgroundColor,
      ),
      body: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          if (state is ArticlesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticlesFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Error: ${state.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is ArticlesSuccess) {
            if (state.articles.isEmpty) {
              return const Center(
                child: Text(
                  "No articles available",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    title: CustomText(text: article.title, color: Colors.black),
                    subtitle: CustomText(text: article.subtitle, fontSize: 12, color: Colors.grey),
                    leading: article.imageUrl != null
                        ? Image.network(article.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArticleEditPage(article: article),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context,article.imageId ,article.documentId,),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No articles available"));
        },
      ),
    );
  }
}
