import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      constraints: BoxConstraints(maxWidth: 150, maxHeight: 150),
      child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
    );
  }
}
