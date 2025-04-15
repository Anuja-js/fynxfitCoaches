import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_event.dart';
import 'package:fynxfitcoaches/bloc/articles/articles_state.dart';
import 'package:fynxfitcoaches/models/article_model.dart';
import 'package:fynxfitcoaches/utils/constants.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ArticlesBloc() : super(ArticlesInitial()) {
    on<UploadArticlesEvent>(uploadArticleImage);
    on<DeleteArticlesEvent>(deleteArticle);
    on<FetchCoachArticlesEvent>(fetchCoachArticles);
    on<UpdateArticlesEvent>(updateArticle);// New event
    // on<DeleteCoachArticleEvent>(_onDeleteArticle);
  }

  Future<void> uploadArticleImage(UploadArticlesEvent event, Emitter<ArticlesState> emit) async {
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

      emit(ArticlesSuccess([]));
    } catch (e) {

      emit(ArticlesFailure(e.toString()));
    }
  }

  // Future<void> _deleteArticleImage(DeleteArticlesEvent event, Emitter<ArticlesState> emit) async {
  //   emit(ArticlesLoading());
  //
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       emit(ArticlesFailure("User is not authenticated"));
  //       return;
  //     }
  //
  //     // Fetch the article document to check the owner
  //     DocumentSnapshot doc = await _firestore.collection("Articles").doc(event.documentId).get();
  //     if (!doc.exists || doc["userId"] != user.uid) {
  //       emit(ArticlesFailure("You don't have permission to delete this article"));
  //       return;
  //     }
  //
  //     // Delete from Cloudinary
  //     await deleteImageFromCloudinary(event.imageId);
  //
  //     // Delete from Firestore
  //     await _firestore.collection("Articles").doc(event.documentId).delete();
  //
  //     emit(ArticlesDelete());
  //   } catch (e) {
  //     emit(ArticlesFailure(e.toString()));
  //   }
  // }

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
  Future<void> fetchCoachArticles(FetchCoachArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ArticlesFailure("User not authenticated"));
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Articles")
          .where("userId", isEqualTo: user.uid) // Only where clause (no orderBy)
          .get();


      List<ArticleModel> articles = querySnapshot.docs.map((doc) {
        return ArticleModel(
          documentId: doc.id,
          title: doc["title"]?.toString() ?? "Untitled",
          subtitle: doc["subtitle"]?.toString() ?? "No description",
          imageUrl: doc["imageUrl"]?.toString() ?? "", // Fixed extra space issue
          createdAt: (doc["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
          userId: doc["userId"]?.toString() ?? "",
          imageId: doc["imageId"]?.toString() ?? "",
        );
      }).toList();

      emit(ArticlesSuccess(articles));
    } catch (e) {
      emit(ArticlesFailure(e.toString()));
    }
  }
  Future<void> updateArticle(UpdateArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());

    try {
      // Get the current article data
      DocumentSnapshot doc = await _firestore.collection("Articles").doc(event.articleId).get();

      if (!doc.exists) {
        emit(ArticlesFailure("Article not found"));
        return;
      }

      // Extract existing image URL
      String existingImageUrl = doc["imageUrl"] ?? "";
      String existingImageId = doc["imageId"] ?? "";

      String newImageUrl = existingImageUrl;
      String newImageId = existingImageId;

      // Check if the new image is different and upload to Cloudinary
      if (event.imagePath != null && event.imagePath != existingImageUrl) {
        Map<String, String> cloudinaryData = await uploadImageToCloudinary(event.imagePath!);
        newImageUrl = cloudinaryData["secure_url"]!;
        newImageId = cloudinaryData["public_id"]!;

        // Delete old image from Cloudinary if it exists
        if (existingImageId.isNotEmpty) {
          await deleteImageFromCloudinary(existingImageId);
        }
      }

      // Update Firestore document
      await _firestore.collection("Articles").doc(event.articleId).update({
        "title": event.articleTitle,
        "subtitle": event.articleDescription,
        "imageUrl": newImageUrl,
        "imageId": newImageId,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      // Re-fetch updated articles
      add(FetchCoachArticlesEvent());

    } catch (e) {
      emit(ArticlesFailure(e.toString()));
    }
  }
  Future<void> deleteArticle(DeleteArticlesEvent event, Emitter<ArticlesState> emit) async {
    emit(ArticlesLoading());

    try {
      await deleteCloudinaryimage(event.imageId);

      await _firestore.collection("Articles").doc(event.imageId).delete();

      // Re-fetch articles after deletion
      add(FetchCoachArticlesEvent());

    } catch (e) {
      emit(ArticlesFailure("❌ Failed to delete article: ${e.toString()}"));
    }
  }
  Future<void> deleteCloudinaryimage(String publicId) async {
    try {
      String cloudName = "dswwx1kl4";
      String apiKey = "413491413778726";
      String apiSecret = "GBuMHcOy845fjoI8-2R36MR7UEE";

      String authToken = base64Encode(utf8.encode("$apiKey:$apiSecret"));

      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/destroy";

      Map<String, dynamic> params = {
        "public_ids": publicId,
      };
      Response response = await Dio().delete(
        url,
        data: params,
        options: Options(
          headers: {
            "Authorization": "Basic $authToken",
            "Content-Type": "application/json",
          },
          validateStatus: (status) {
            return status! < 500; // Allows Cloudinary to return status codes without throwing an error
          },
        ),
      );
      // Response response = await Dio().post(
      //   url,
      //   data: params,
      //   options: Options(
      //     headers: {
      //       "Authorization": "Basic $authToken",
      //       "Content-Type": "application/json",
      //     },
      //   ),
      // );

      if (response.statusCode == 200) {
        print("✅ Cloudinary image deleted successfully");
      } else {
        print("⚠️ Failed to delete image. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error deleting image from Cloudinary: $e");
    }
  }

// Future<void> _onDeleteArticle(
  //     DeleteCoachArticleEvent event, Emitter<ArticlesState> emit) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       emit(ArticlesFailure("User not authenticated"));
  //       return;
  //     }
  //
  //     // Delete article from Firestore
  //     await _firestore.collection('Articles').doc(event.articleId).delete();
  //
  //     // Fetch updated list of articles
  //     QuerySnapshot querySnapshot = await _firestore
  //         .collection("Articles")
  //         .where("userId", isEqualTo: user.uid)
  //         .get();
  //
  //     List<ArticleModel> articles = querySnapshot.docs.map((doc) {
  //       return ArticleModel(
  //         documentId: doc.id,
  //         title: doc["title"]?.toString() ?? "Untitled",
  //         subtitle: doc["subtitle"]?.toString() ?? "No description",
  //         imageUrl: doc["imageUrl"]?.toString() ?? "",
  //         createdAt: (doc["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
  //         userId: doc["userId"]?.toString() ?? "",
  //         imageId: doc["imageId"]?.toString() ?? "",
  //       );
  //     }).toList();
  //
  //     // Emit success state with updated articles list
  //     emit(ArticlesSuccess(articles));
  //   } catch (e) {
  //     emit(ArticlesFailure("Failed to delete article: ${e.toString()}"));
  //   }
  // }
  //
  //

}
