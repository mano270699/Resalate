import 'package:flutter/material.dart';

import '../../src/Auth/view/forget_password_otp_screen.dart';
import '../../src/Auth/view/forget_password_screen.dart';
import '../../src/Auth/view/login_screen.dart';
import '../../src/Auth/view/register_screen.dart';
import '../../src/Auth/view/reset_password_screen.dart';
import '../../src/donation/view/donation_details_screen.dart';
import '../../src/from_mosque_to_mosque/views/from_mosque_to_mosque_details_screen.dart';
import '../../src/from_mosque_to_mosque/views/from_mosque_to_mosque_screen.dart';
import '../../src/funerals/view/funerals_details_screen.dart';
import '../../src/home/views/all_feed_screen.dart';
import '../../src/home/views/all_funerals_screen.dart';
import '../../src/home/views/all_lesson_screen.dart';
import '../../src/layout/screens/user_bottom_navigation_screen.dart';
import '../../src/lessons/view/lesson_details_screen.dart';
import '../../src/live_feed/view/live_feed_details_screen.dart';
import '../../src/my_mosque/views/my_mosque_screen.dart';
import '../../src/nearest_mosque/views/nearest_mosque.dart';
import '../../src/notification/view/notification_screen.dart';
import '../../src/profile/views/edit_profile_screen.dart';
import '../../src/profile/views/faq_screen.dart';
import '../../src/profile/views/web_view_page.dart';
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
      case FaqScreen.routeName:
        return MaterialPageRoute(builder: (_) => FaqScreen());

      case FromMosqueToMosqueScreen.routeName:
        return MaterialPageRoute(builder: (_) => FromMosqueToMosqueScreen());
      case NearestMosque.routeName:
        return MaterialPageRoute(builder: (_) => const NearestMosque());
      case AllFeedLiveScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AllFeedLiveScreen());
      case AllLessonsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AllLessonsScreen());
      case AllFuneralsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AllFuneralsScreen());
      case DonationDetailsScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => DonationDetailsScreen(
                  donationId: args["id"],
                ));
      case LiveFeedDetailsScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => LiveFeedDetailsScreen(
                  id: args["id"],
                ));
      case LessonDetailsScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => LessonDetailsScreen(
                  id: args["id"],
                ));
      case FuneralsDetailsScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => FuneralsDetailsScreen(
                  id: args["id"],
                ));
      case FromMosqueToMosqueDetailsScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => FromMosqueToMosqueDetailsScreen(
                  id: args["id"],
                ));
      case WebViewPage.routeName:
        final args = settings.arguments as Map;
        return MaterialPageRoute(
            builder: (_) => WebViewPage(
                  title: args["title"],
                  url: args["url"],
                ));
      case MyMosqueScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => MyMosqueScreen(
                  id: args["id"],
                ));
      case EditProfileScreen.routeName:
        final args = settings.arguments as Map;

        return MaterialPageRoute(
            builder: (_) => EditProfileScreen(
                  viewModel: args["viewModel"],
                ));
      case NotificationScreen.routeName:
        return MaterialPageRoute(builder: (_) => NotificationScreen());

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
