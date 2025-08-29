import 'package:flutter/material.dart';

import '../../layout/screens/user_bottom_navigation_screen.dart';

class SplashScreenViewModel {
  SplashScreenViewModel();
  init(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 0),
      () {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainBottomNavigationScreen.routeName,
            (route) => false,
          );
        }
      },
    );
  }
}
