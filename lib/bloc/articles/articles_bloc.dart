import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_event.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_state.dart';
import 'package:fynxfitcoaches/utils/constants.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ArticlesBloc() : super(ArticlesInitial()) {
    on<UploadArticlesEvent>(_uploadArticleImage);
    on<DeleteArticlesEvent>(_deleteArticleImage);
  }

  Future<void> _uploadArticleImage(UploadArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());

    try {
      // Ensure the user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ArticlesFailure("User is not authenticated"));
        return;
      }

      // Upload image to Cloudinary and get URL & Public ID
      Map<String, String> cloudinaryData = await uploadImageToCloudinary(event.imagePath);

      // Store in Firestore
      DocumentReference docRef = await _firestore.collection("Articles").add({
        "title": event.articleTitle,
        "subtitle": event.ArticleDescription,
        "imageUrl": cloudinaryData["secure_url"],
        "imageId": cloudinaryData["public_id"],
        "createdAt": FieldValue.serverTimestamp(),
        "userId": user.uid, // Store user ID for ownership validation
      });

      // Update document to include its ID
      await docRef.update({"documentId": docRef.id});

      emit(ArticlesSuccess());
    } catch (e) {

      emit(ArticlesFailure(e.toString()));
    }
  }

  Future<void> _deleteArticleImage(DeleteArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ArticlesFailure("User is not authenticated"));
        return;
      }

      // Fetch the article document to check the owner
      DocumentSnapshot doc = await _firestore.collection("Articles").doc(event.documentId).get();
      if (!doc.exists || doc["userId"] != user.uid) {
        emit(ArticlesFailure("You don't have permission to delete this article"));
        return;
      }

      // Delete from Cloudinary
      await deleteImageFromCloudinary(event.imageId);

      // Delete from Firestore
      await _firestore.collection("Articles").doc(event.documentId).delete();

      emit(ArticlesDelete());
    } catch (e) {
      emit(ArticlesFailure(e.toString()));
    }
  }

  Future<Map<String, String>> uploadImageToCloudinary(String filePath) async {
    try {
      String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/image/upload";
      String uploadPreset = CloudinaryConstants.CLOUDINARY_UPLOAD_PRESET;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: "image.jpg"),
        "upload_preset": uploadPreset,
      });

      Response response = await Dio().post(cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        return {
          "secure_url": response.data["secure_url"],
          "public_id": response.data["public_id"],
        };
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }
  Future<void> deleteImageFromCloudinary(String publicId) async {
    try {
      String cloudinaryDeleteUrl =
          "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/image/destroy";

      int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Convert to seconds
      String signature = CloudinaryConstants.getSignature(publicId);

      FormData formData = FormData.fromMap({
        "public_id": publicId,
        "api_key": CloudinaryConstants.CLOUDINARY_API_KEY,
        "timestamp": timestamp.toString(),
        "signature": signature,
      });

      Response response = await Dio().post(cloudinaryDeleteUrl, data: formData);

      if (response.statusCode != 200) {
        throw Exception("Failed to delete image from Cloudinary");
      }
    } catch (e) {
      print("Error deleting image: $e");
      throw e;
    }
  }

}
