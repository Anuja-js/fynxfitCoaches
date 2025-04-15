import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileImageState {
  final File? imageprofile;
  final String? imageUrlprofile;
  final bool isLoadingprofile;
  final String? errorprofile;

  ProfileImageState({this.imageprofile, this.imageUrlprofile, this.isLoadingprofile = false, this.errorprofile});
}

class ProfileImageCubit extends Cubit<ProfileImageState> {
  ProfileImageCubit() : super(ProfileImageState());

  final picker = ImagePicker();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ProfileImageState(imageprofile: File(pickedFile.path), isLoadingprofile: false));
    }
  }

  Future<void> uploadToCloudinary(File imageFile, String userId) async {
    emit(ProfileImageState(imageUrlprofile: imageFile.path, isLoadingprofile: true));

    String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/${CloudinaryConstants.CLOUDINARY_CLOUD_NAME}/image/upload";
    String uploadPreset = CloudinaryConstants.CLOUDINARY_UPLOAD_PRESET;

    var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(await response.stream.bytesToString());
      final String imageUrl = jsonResponse['secure_url']; // Get the uploaded image URL
      final String publicId = jsonResponse['public_id']; // Get Cloudinary image ID

      emit(ProfileImageState(imageUrlprofile: imageUrl, isLoadingprofile: false));

      await saveToFirestore(imageUrl, publicId, userId,);
    } else {
      emit(ProfileImageState(isLoadingprofile: false, errorprofile: "Upload failed"));
    }
  }

  Future<void> saveToFirestore(String imageUrl, String publicId, String userId) async {
    await firestore.collection('coaches').doc(userId).set({
      'uid': userId,
      'profileImage': imageUrl,
      "profileonboading":true,
      'cloudinaryProfileImageIdProfile': publicId,
    }, SetOptions(merge: true));
  }
}
