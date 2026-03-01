import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../models/lesson_details.dart';

abstract class LessonsRepository {
  Future<Either<String, LessonDetailsModel>> getLessonDetails(
      {required int id});
}

class LessonsRepositoryImpl extends LessonsRepository {
  final NetworkService _networkService;

  LessonsRepositoryImpl(this._networkService);

  @override
  Future<Either<String, LessonDetailsModel>> getLessonDetails(
      {required int id}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "lesson/$id?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      LessonDetailsModel res = LessonDetailsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
