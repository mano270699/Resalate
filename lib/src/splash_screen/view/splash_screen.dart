// import 'package:flutter/material.dart';

// import 'package:lottie/lottie.dart';
// import 'package:resalate/src/splash_screen/view/splash_screen_view_model.dart';

// import '../../../core/base/dependency_injection.dart';
// import '../../../core/common/app_colors/app_colors.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//   static const String routeName = 'Splash Screen';

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   final viewModel = sl<SplashScreenViewModel>();
//   late AnimationController _logoController;

//   @override
//   void initState() {
//     _logoController = AnimationController(vsync: this);
//     _logoController.addListener(() {
//       if (_logoController.value > 0.7) {
//         _logoController.stop();

//         setState(() {});
//         Future.delayed(const Duration(seconds: 1), () {
//           viewModel.init(context);
//           setState(() {});
//         });

//         //navigate to welcome page
//         // Future.delayed(const Duration(seconds: 3), () {
//         //   Navigator.pushNamed(context, AppRouter.welcomePage);
//         // });
//       }
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: Lottie.asset(
//               'assets/json/logo.json',
//               controller: _logoController,
//               onLoaded: (composition) {
//                 _logoController
//                   ..duration = composition.duration
//                   ..forward();
//               },
//             ),

//             //  SvgPicture.asset(
//             //   AppIconSvg.resalateLogo2,
//             //   height: 200.h,
//             // ),
//           ),
//           // 20.h.verticalSpace,
//           // AppText(
//           //   text: "Resalty",
//           //   model: AppTextModel(
//           //       style: AppFontStyleGlobal(AppLocalizations.of(context)!.locale)
//           //           .heading1
//           //           .copyWith(
//           //             color: AppColors.lightBlack,
//           //           )),
//           // ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:resalate/src/splash_screen/view/splash_screen_view_model.dart';

import '../../../core/base/dependency_injection.dart';
import '../../../core/common/app_colors/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = 'Splash Screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final viewModel = sl<SplashScreenViewModel>();
  late AnimationController _logoController;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _logoController = AnimationController(vsync: this);
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Delay showing the logo for a specific time after the animation
        _delayAfterAnimation();
      }
    });
  }

  void _delayAfterAnimation() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Delay after animation
    if (!mounted) return; // ✅ Correct way in a State class
    viewModel.init(context); // Safe to use context now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          'assets/json/logo.json',
          controller: _logoController,
          onLoaded: (composition) {
            // Set the duration of the animation controller
            _logoController
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }
}
