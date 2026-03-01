import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../models/funerals_details.dart';

abstract class FuneralsRepository {
  Future<Either<String, FuneralsDetailsModel>> getFuneralDetails(
      {required int id});
}

class FuneralsRepositoryImpl extends FuneralsRepository {
  final NetworkService _networkService;

  FuneralsRepositoryImpl(this._networkService);

  @override
  Future<Either<String, FuneralsDetailsModel>> getFuneralDetails(
      {required int id}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "funerals/$id?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      FuneralsDetailsModel res = FuneralsDetailsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
