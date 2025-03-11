import 'package:flutter/material.dart';
class IconSplashImage extends StatelessWidget {
  const IconSplashImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/logo_white.png",
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
    );
  }
}

