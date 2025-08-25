import 'package:flutter/material.dart';

import '../../src/Auth/login/view/forget_password_otp_screen.dart';
import '../../src/Auth/login/view/forget_password_screen.dart';
import '../../src/Auth/login/view/login_screen.dart';
import '../../src/Auth/login/view/register_screen.dart';
import '../../src/Auth/login/view/reset_password_screen.dart';
import '../../src/from_mosque_to_mosque/views/from_mosque_to_mosque_screen.dart';
import '../../src/layout/screens/user_bottom_navigation_screen.dart';
import '../../src/nearest_mosque/views/nearest_mosque.dart';
import '../../src/splash_screen/view/splash_screen.dart';

class RouteGenerator {
  Map<String, dynamic> routs;
  RouteGenerator({
    required this.routs,
  });
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainBottomNavigationScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const MainBottomNavigationScreen());
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case ForgetPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case ForgetPasswordOTPScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => ForgetPasswordOTPScreen(
                  email: args["email"],
                ));
      case ResetPasswordScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
                  email: args["email"],
                  code: args["code"],
                ));
      case RegesterScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RegesterScreen());
      case FromMosqueToMosqueScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const FromMosqueToMosqueScreen());
      case NearestMosque.routeName:
        return MaterialPageRoute(builder: (_) => const NearestMosque());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
