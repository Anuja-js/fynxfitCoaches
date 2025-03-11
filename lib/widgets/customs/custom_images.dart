import 'package:flutter/material.dart';

class CustomImages extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomImages({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height / 2,
      fit: fit,
    );
  }
}
