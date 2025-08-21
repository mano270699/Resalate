import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import '../../src/layout/screens/main_screen_view_model.dart';
import '../../src/splash_screen/view/splash_screen_view_model.dart';
import '../common/config.dart';
import '../util/api_interceptor/api_interceptor.dart';
import '../util/localization/cubit/localization_cubit.dart';
import '../util/localization/localization_cache_helper.dart';
import '../util/localization/models/localization_model.dart';
import '../util/network_service.dart';
import '../util/routes/routes_reader.dart';
import 'route_genrator.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dynamicRouts = await load();

  sl.registerFactory(() => dynamicRouts);

  sl.registerFactory(() => RouteGenerator(routs: sl()));

  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerFactory(() => LocalizationCacheHelper());

  sl.registerFactory(() => LocalizationCubit(sl()));

  sl.registerLazySingleton<NetworkService>(() => NetworkServiceImpl());

  sl.registerLazySingleton(() => Dio(
        BaseOptions(
          baseUrl: Config.baseUrl,
          headers: Config.headers,
        ),
      )..interceptors.add(
          ApiInterceptor(),
        ));

  /// VIEW MODELS

  sl.registerFactory(() => SplashScreenViewModel());
  sl.registerFactory(() => MainScreenViewModel());

  /// USECASES

  /// REPOSITORIES

  /// DATA SOURCE

  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  sl.registerFactory<LocalizationModelAdapter>(
      () => LocalizationModelAdapter());
  Hive.registerAdapter(LocalizationModelAdapter());

  Box box = await Hive.openBox('box');
  sl.registerFactory(() => box);
}
