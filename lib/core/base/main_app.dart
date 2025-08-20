import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resalate/src/splash_screen/view/splash_screen.dart';

// import '../../src/main_screen/view/main_screen.dart';
import '../common/app_colors/app_colors.dart';
import '../util/localization/app_localizations.dart';
import '../util/localization/cubit/localization_cubit.dart';
import 'dependency_injection.dart';
import 'route_genrator.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<LocalizationCubit>()..getSavedLanguage(),
        ),
      ],
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          if (state is ChangeLanguageState) {
            return ScreenUtilInit(
                designSize: const Size(375, 812),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Resalate',
                    theme: ThemeData(
                      scaffoldBackgroundColor:
                          AppColors.scaffoldBackgroundColor,
                      appBarTheme: const AppBarTheme(
                        color: AppColors.appBar,
                        elevation: 0,
                      ),
                      progressIndicatorTheme: const ProgressIndicatorThemeData(
                          color: AppColors.white),
                    ),
                    locale: state.locale,
                    supportedLocales: const [
                      Locale('en', 'US'),
                      Locale('ar', 'SA'),
                    ],
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      DefaultMaterialLocalizations.delegate,
                      DefaultWidgetsLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    localeResolutionCallback: (locale, supportedLocales) {
                      for (var supportedLocale in supportedLocales) {
                        if (supportedLocale.languageCode ==
                            locale?.languageCode) {
                          return supportedLocale;
                        }
                      }
                      return supportedLocales.first;
                    },
                    onGenerateRoute: RouteGenerator.generatedRoute,
                    initialRoute: SplashScreen.routeName,
                  );
                });
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
