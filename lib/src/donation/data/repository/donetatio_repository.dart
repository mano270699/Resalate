import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';
import '../models/donation_details_model.dart';
import '../models/donation_model.dart';

abstract class DonetatioRepository {
  Future<Either<String, DonationsResponse>> getDonationData(
      {required int page});
  Future<Either<String, DonationsDetailsResponse>> getDonationDetails(
      {required int id});
}

class DonetatioRepositoryImpl extends DonetatioRepository {
  final NetworkService _networkService;

  DonetatioRepositoryImpl(this._networkService);

  @override
  Future<Either<String, DonationsResponse>> getDonationData(
      {required int page}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "donations?per_page=10&page=$page&lang=${localizationCacheHelper.getLanguageCode()}",
      );
      DonationsResponse res = DonationsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DonationsDetailsResponse>> getDonationDetails(
      {required int id}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "donations/$id?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      DonationsDetailsResponse res =
          DonationsDetailsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
