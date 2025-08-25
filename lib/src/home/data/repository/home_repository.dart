import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/src/home/data/models/home_data_model.dart';
import 'package:resalate/src/home/data/models/lessons_model.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';
import '../models/donation_model.dart';
import '../models/funerial_model.dart';
import '../models/live_model.dart';

abstract class HomeRepository {
  Future<Either<String, HomeDataModel>> getHomeData();
  Future<Either<String, DonationsResponse>> getDonationData();
  Future<Either<String, LiveFeedsResponse>> getLiveFeed();
  Future<Either<String, LessonsResponse>> getLessons();
  Future<Either<String, FuneralsResponse>> getFuneralsData();
}

class HomeRepositoryImpl extends HomeRepository {
  final NetworkService _networkService;

  HomeRepositoryImpl(this._networkService);
  @override
  Future<Either<String, HomeDataModel>> getHomeData() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "app-options?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      HomeDataModel res = HomeDataModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DonationsResponse>> getDonationData() async {
    try {
      final response = await _networkService.get(
        "donations?per_page=5&page=1",
      );
      DonationsResponse res = DonationsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LiveFeedsResponse>> getLiveFeed() async {
    try {
      final response = await _networkService.get(
        "live-feed?per_page=10&page=1",
      );
      LiveFeedsResponse res = LiveFeedsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LessonsResponse>> getLessons() async {
    try {
      final response = await _networkService.get(
        "lessons?per_page=10&page=1",
      );
      LessonsResponse res = LessonsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FuneralsResponse>> getFuneralsData() async {
    try {
      final response = await _networkService.get(
        "funerals?per_page=10&page=1",
      );
      FuneralsResponse res = FuneralsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
