import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../models/masjed_to_masjed_detais_model.dart';
import '../models/masjed_to_masjed_model.dart';

abstract class MasjedToMasjedRepository {
  Future<Either<String, MasjedToMasjedModel>> getMasjedToMasjed({
    required int page,
  });
  Future<Either<String, MasjedToMasjedDetailsModel>> getMasjedToMasjedDetails({
    required int id,
  });
}

class MasjedToMasjedRepositoryImpl extends MasjedToMasjedRepository {
  final NetworkService _networkService;

  MasjedToMasjedRepositoryImpl(this._networkService);
  @override
  Future<Either<String, MasjedToMasjedModel>> getMasjedToMasjed({
    required int page,
  }) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "masjid-to-masjid?per_page=10&page=$page&lang=${localizationCacheHelper.getLanguageCode()}",
      );
      MasjedToMasjedModel res = MasjedToMasjedModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MasjedToMasjedDetailsModel>> getMasjedToMasjedDetails(
      {required int id}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "masjid-to-masjid/$id?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      MasjedToMasjedDetailsModel res =
          MasjedToMasjedDetailsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
