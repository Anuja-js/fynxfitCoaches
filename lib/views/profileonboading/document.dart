import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fynxfitcoaches/bloc/document/documents_bloc.dart';
import 'package:fynxfitcoaches/theme.dart';
import 'package:fynxfitcoaches/utils/constants.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_elevated_button.dart';
import 'package:fynxfitcoaches/widgets/customs/custom_text.dart';

class DocumentUploadScreen extends StatelessWidget {
  final PageController controller;
  String uid;

  DocumentUploadScreen({Key? key, required this.controller,required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentUploadCubit(),
      child: Scaffold(
        backgroundColor: AppThemes.darkTheme.scaffoldBackgroundColor,
        body: BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
          builder: (context, state) {
            final cubit = context.read<DocumentUploadCubit>();

            return
                Padding(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [sh30,
                  CustomText(
                    text: "Upload Your Documents",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),sh10,
                  CustomText(
                    text: "Please upload the necessary documents to proceed.",
                    fontSize: 13.sp,
                  ),sh10,
                  CustomText(
                    text: "Ensure your documents are clear and in the correct format.",
                    fontSize: 10.sp,
                    overflow: TextOverflow.visible,
                    color: AppThemes.darkTheme.dividerColor,
                  ),
                  CustomText(
                    text: "Accepted formats: PNG, JPG",
                    fontSize: 10.sp,
                    color: AppThemes.darkTheme.primaryColor,
                  ),
sh10,
                  state.image != null
                      ? Image.file(state.image!, width: 200.w, height: 200.h, fit: BoxFit.cover)
                      : Container(
                    width: MediaQuery.of(context).size.width/1.7,
                    height: 200.h,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 100.w, color: Colors.grey[600]),
                  ),
sh20,
                  SizedBox(width: MediaQuery.of(context).size.width/1.7,
                    child: CustomElevatedButton(
                          backgroundColor: AppThemes.darkTheme.primaryColor,
                          textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                          text: "Select image",


                      onPressed: () => cubit.pickImage(),
                    ),
                  ),
                  Spacer(),
                  if (state.isLoading) Center(child: CircularProgressIndicator()),
                  if (state.image != null) ...[
                    SizedBox(width: MediaQuery.of(context).size.width,
                      child: CustomElevatedButton(
                        backgroundColor: AppThemes.darkTheme.primaryColor,
                        textColor: AppThemes.darkTheme.scaffoldBackgroundColor,
                        text: "Next",
                        onPressed: () async{
                         await cubit.uploadToCloudinary(state.image!, uid);
                          controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      ),
                    ),

                  ],
                  if (state.error != null)
                    Text(state.error!, style: TextStyle(color: Colors.red)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
