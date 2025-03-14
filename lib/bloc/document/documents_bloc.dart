import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DocumentUploadState {
  final File? image;
  final String? imageUrl;
  final bool isLoading;
  final String? error;

  DocumentUploadState({this.image, this.imageUrl, this.isLoading = false, this.error});
}

class DocumentUploadCubit extends Cubit<DocumentUploadState> {
  DocumentUploadCubit() : super(DocumentUploadState());

  final picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(DocumentUploadState(image: File(pickedFile.path), isLoading: false));
      // await uploadToCloudinary(File(pickedFile.path));
    }
  }

  Future<void> uploadToCloudinary(File imageFile, String userId) async {
    emit(DocumentUploadState(imageUrl: imageFile.path, isLoading: true));

    String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/image/upload";
    String uploadPreset = CloudinaryConstants.CLOUDINARY_UPLOAD_PRESET;

    var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(await response.stream.bytesToString());
      final String imageUrl = jsonResponse['secure_url']; // Get the image URL
      final String publicId = jsonResponse['public_id']; // Get the Cloudinary image ID

      emit(DocumentUploadState(imageUrl: imageUrl, isLoading: false));

      await saveToFirestore(imageUrl, publicId, userId);
    } else {
      emit(DocumentUploadState(isLoading: false, error: "Upload failed"));
    }
  }
  Future<void> saveToFirestore(String imageUrl, String publicId, String userId) async {
    await firestore.collection('coaches').doc(userId).set({
      'uid': userId,
      'documentImage': imageUrl,
      'cloudinaryImageId': publicId,
    }, SetOptions(merge: true));
  }


}
