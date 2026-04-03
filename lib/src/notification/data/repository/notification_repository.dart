import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/token_util.dart';
import 'package:resalate/src/notification/data/models/notification_model.dart';
import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';

abstract class NotificationRepository {
  Future<Either<String, NotificationModel>> getNotifications();
}

class NotificationRepositoryImpl extends NotificationRepository {
  final NetworkService _networkService;

  NotificationRepositoryImpl(this._networkService);
  @override
  Future<Either<String, NotificationModel>> getNotifications() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
          "notifications/${await UserIdUtil.getUserIdFromMemory()}?lang=${localizationCacheHelper.getLanguageCode()}");
      NotificationModel res = NotificationModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
