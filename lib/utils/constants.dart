import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
 SizedBox sh10=SizedBox(height: 10.h,);
 SizedBox sh20=SizedBox(height: 20.h,);
 SizedBox sh30=SizedBox(height: 30.h,);
 SizedBox sh50=SizedBox(height: 50.h,);
 SizedBox sw10=SizedBox(width: 10.w,);
 SizedBox sw5=SizedBox(width: 5.w,);
 SizedBox sw20=SizedBox(width: 20.w,);
class CloudinaryConstants {
 static const String CLOUDINARY_CLOUD_NAME = "dswwx1kl4";
 static const String CLOUDINARY_API_KEY = "413491413778726";
 static const String CLOUDINARY_API_SECRET = "GBuMHcOy845fjoI8-2R36MR7UEE";
 static const String CLOUDINARY_UPLOAD_PRESET = "preset-for-image-upload";
 static String authToken = base64Encode(utf8.encode("$CLOUDINARY_API_KEY:$CLOUDINARY_API_SECRET"));

  static String getSignature(String publicId) {
   int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
   String data = "public_id=$publicId&timestamp=$timestamp${CLOUDINARY_API_SECRET}";

   var signature = sha1.convert(utf8.encode(data)).toString();

   return signature;
  }
 }