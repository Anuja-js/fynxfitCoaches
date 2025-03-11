import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_bloc.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_event.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_state.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class ArticleUploadPage extends StatefulWidget {
  const ArticleUploadPage({super.key});

  @override
  _ArticleUploadPageState createState() => _ArticleUploadPageState();
}

class _ArticleUploadPageState extends State<ArticleUploadPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _uploadArticle() {
    if (_selectedImage != null && titleController.text.isNotEmpty) {
      context.read<ArticlesBloc>().add(
        UploadArticlesEvent(
          imagePath: _selectedImage!.path,
          articleTitle: titleController.text,
          ArticleDescription: descriptionController.text,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image and enter a title")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "Add Article",
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        backgroundColor: AppThemes.darkTheme.appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppThemes.darkTheme.appBarTheme.foregroundColor,
            size: 15,
          ),
        ),
      ),
      body: BlocListener<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          if (state is ArticlesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Article uploaded successfully!")),
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
               sh20,
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Article Description",
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
                sh20,
                _selectedImage == null
                    ? const CustomText(text: "No image selected", )
                    : Center(child: Image.file(_selectedImage!, height:MediaQuery.of(context).size.height/4, width: MediaQuery.of(context).size.width/1, fit: BoxFit.cover)),
              sh10,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomElevatedButton(
                backgroundColor: AppThemes.darkTheme.primaryColor,
                textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                text:"Pick Article Image",
                  onPressed: _pickImage,
                ),),
                const SizedBox(height: 20),
                BlocBuilder<ArticlesBloc, ArticlesState>(
                  builder: (context, state) {
                    if (state is ArticlesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return     SizedBox(
                        width: MediaQuery.of(context).size.width,
                    child: CustomElevatedButton(
                    backgroundColor: AppThemes.darkTheme.primaryColor,
                    textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                    text:"Upload Article",
                      onPressed: _uploadArticle,
                    ));
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
