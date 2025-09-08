import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resalate/src/from_mosque_to_mosque/data/repository/masjed_to_masjed_repository.dart';
import 'package:resalate/src/profile/logic/profile_view_model.dart';
import '../../src/Auth/data/repository/auth_repository.dart';
import '../../src/Auth/logic/auth_view_model.dart';
import '../../src/donation/data/repository/donetatio_repository.dart';
import '../../src/donation/logic/donations_view_model.dart';
import '../../src/from_mosque_to_mosque/logic/masjed_to_masjed_view_model.dart';
import '../../src/funerals/data/repository/funerals_repository.dart';
import '../../src/funerals/logic/funerals_view_model.dart';
import '../../src/home/data/repository/home_repository.dart';
import '../../src/home/logic/home_view_model.dart';
import '../../src/layout/screens/main_screen_view_model.dart';
import '../../src/lessons/data/repository/lesson_repository.dart';
import '../../src/lessons/logic/lesson_viewmodel.dart';
import '../../src/live_feed/data/repository/live_feed_repository.dart';
import '../../src/live_feed/logic/live_feed_viewmodel.dart';
import '../../src/my_mosque/data/repository/masjed_repository.dart';
import '../../src/my_mosque/logic/masjed_view_model.dart';
import '../../src/nearest_mosque/data/repository/nearby_masjeds_repository.dart';
import '../../src/nearest_mosque/logic/nearby_masjeds_view_model.dart';
import '../../src/notification/data/repository/notification_repository.dart';
import '../../src/notification/logic/notification_view_model.dart';
import '../../src/profile/data/repository/profile_repository.dart';
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

  /// VIEW Repository
  sl.registerFactory(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => HomeRepositoryImpl(sl()));
  sl.registerFactory(() => DonetatioRepositoryImpl(sl()));
  sl.registerFactory(() => MasjidRepositoryImpl(sl()));
  sl.registerFactory(() => ProfileRepositoryImpl(sl()));
  sl.registerFactory(() => NotificationRepositoryImpl(sl()));
  sl.registerFactory(() => MasjedToMasjedRepositoryImpl(sl()));
  sl.registerFactory(() => NearbyMasjedsRepositoryImpl(sl()));
  sl.registerFactory(() => LiveFeedRepositoryImpl(sl()));
  sl.registerFactory(() => LessonsRepositoryImpl(sl()));
  sl.registerFactory(() => FuneralsRepositoryImpl(sl()));

  /// VIEW MODELS

  sl.registerFactory(() => SplashScreenViewModel());
  sl.registerFactory(() => MainScreenViewModel());
  sl.registerFactory(() => AuthViewModel(authRepositoryImpl: sl()));
  sl.registerFactory(() => HomeViewModel(sl()));
  sl.registerFactory(() => MasjedViewModel(sl()));
  sl.registerFactory(() => ProfileViewModel(sl()));
  sl.registerFactory(() => NotificationViewModel(sl()));
  sl.registerFactory(() => MasjedToMasjedViewModel(sl()));
  sl.registerFactory(() => NearbyMasjedsViewModel(sl()));
  sl.registerFactory(() => LiveFeedViewModel(sl()));
  sl.registerFactory(() => LessonViewModel(sl()));
  sl.registerFactory(() => FuneralsViewModel(sl()));
  sl.registerFactory(() => DonationsViewModel(donetatioRepositoryImpl: sl()));

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
