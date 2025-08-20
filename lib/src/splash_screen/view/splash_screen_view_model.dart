import 'package:flutter/material.dart';
import 'package:resalate/src/Auth/login/view/login_screen.dart';
// import 'package:resalate/src/layout/screens/user_bottom_navigation_screen.dart';

// import '../../../core/util/token_util.dart';

class SplashScreenViewModel {
  SplashScreenViewModel();
  init(BuildContext context) {
    debugPrint("in init");
    // if (TokenUtil.getTokenFromMemory().isNotEmpty) {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushNamed(
        context,
        LoginScreen.routeName,
      ),
    );
    // } else {
    // Future.delayed(
    //   const Duration(seconds: 3),
    //   () => Navigator.pushNamed(
    //     context,
    //     LoginScreen.routeName,
    //   ),
    // );
    // }
  }
}
