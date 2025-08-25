import 'package:flutter/material.dart';
import 'package:resalate/src/Auth/login/view/login_screen.dart';

import '../../../core/util/token_util.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
// import 'package:resalate/src/layout/screens/user_bottom_navigation_screen.dart';

// import '../../../core/util/token_util.dart';

class SplashScreenViewModel {
  SplashScreenViewModel();
  init(BuildContext context) async {
    debugPrint("in init");

    final token = await TokenUtil.getTokenFromMemory();
    if (token.isNotEmpty) {
      Future.delayed(
        const Duration(seconds: 0),
        () => Navigator.pushNamedAndRemoveUntil(
          context,
          MainBottomNavigationScreen.routeName,
          (route) => false,
        ),
      );
    } else {
      Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushNamed(
          context,
          LoginScreen.routeName,
        ),
      );
    }
  }
}
