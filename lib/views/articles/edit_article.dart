import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_bloc.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_event.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_field.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/models/article_model.dart';

class ArticleEditPage extends StatefulWidget {
  final ArticleModel article;
  const ArticleEditPage({super.key, required this.article});

  @override
  _ArticleEditPageState createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.article.title);
    descriptionController = TextEditingController(text: widget.article.subtitle);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _updateArticle() {
    if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Description cannot be empty")),
      );
      return;
    }

    String imagePath = _selectedImage != null ? _selectedImage!.path : widget.article.imageUrl;

    context.read<ArticlesBloc>().add(
      UpdateArticlesEvent(
        articleId: widget.article.documentId,
        imagePath: imagePath,
        articleTitle: titleController.text.trim(),
        articleDescription: descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "Edit Article",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppThemes.darkTheme.appBarTheme.backgroundColor,
      ),
      body: BlocListener<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          if (state is ArticlesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Article updated successfully!")),
            );
            Navigator.pop(context);
          } else if (state is ArticlesFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: titleController,
                  hintText: "Article Title",
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Article Description",
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                _selectedImage == null && widget.article.imageUrl != null
                    ? Center(
                  child: Image.network(widget.article.imageUrl!,
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover),
                )
                    : _selectedImage != null
                    ? Center(
                  child: Image.file(
                    _selectedImage!,
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Center(child: Text("No image selected")),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomElevatedButton(
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                    text: "Pick New Image",
                    onPressed: _pickImage,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<ArticlesBloc, ArticlesState>(
                  builder: (context, state) {
                    if (state is ArticlesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomElevatedButton(
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                        text: "Update Article",
                        onPressed: _updateArticle,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
