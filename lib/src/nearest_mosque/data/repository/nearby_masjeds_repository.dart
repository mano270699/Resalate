import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../models/nearby_masjids_model.dart';

abstract class NearbyMasjedsRepository {
  Future<Either<String, NearbyMasjidsModel>> getNearbyMasjeds(
      {required String lat, required String lng, required String radius});
}

class NearbyMasjedsRepositoryImpl extends NearbyMasjedsRepository {
  final NetworkService _networkService;

  NearbyMasjedsRepositoryImpl(this._networkService);

  @override
  Future<Either<String, NearbyMasjidsModel>> getNearbyMasjeds(
      {required String lat,
      required String lng,
      required String radius}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "nearby-masjids?lat=$lat&lng=$lng&radius=$radius&lang=${localizationCacheHelper.getLanguageCode()}",
      );
      NearbyMasjidsModel res = NearbyMasjidsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
