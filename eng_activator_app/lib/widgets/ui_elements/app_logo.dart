import 'package:eng_activator_app/shared/constants.dart';
import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: CircleAvatar(
        child: Text('exenge'),
        backgroundColor: Color(AppColors.yellow),
        radius: 50,
      ),
    );
  }
}
