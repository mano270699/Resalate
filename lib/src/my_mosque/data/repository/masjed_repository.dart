import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/token_util.dart';
import 'package:resalate/src/my_mosque/data/models/countries_model.dart';

import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';

import '../models/announcement_model.dart';
import '../models/cities_model.dart';
import '../models/follow_masjed_model.dart';
import '../models/location_model.dart';
import '../models/masjed_details_model.dart';
import '../models/masjed_list_model.dart';
import '../models/province_model.dart';
import '../models/user_masjeds_model.dart';

abstract class MasjidRepository {
  Future<Either<String, MasjidListResponse>> getMasjedsList({
    required int page,
    required String city,
    required String province,
    required String country,
  });
  Future<Either<String, MasjidDetailsResponse>> getMasjedsDetails({
    required int id,
  });
  Future<Either<String, CountriesResponseModel>> getCountries();
  Future<Either<String, ProvincesResponseModel>> getProvinces(
      {required int cityId});
  Future<Either<String, CitiesResponseModel>> getCities(
      {required int countryId});
  Future<Either<String, UserMasjedsModel>> getUserMasjedsList();
  Future<Either<String, FollowMasjedResponse>> followMasjed({
    required int masjedId,
  });
  Future<Either<String, FollowMasjedResponse>> unfollowMasjed({
    required int masjedId,
  });
  Future<Either<String, LocationsModels>> getLocations();
  Future<Either<String, AnnouncementsResponse>> getAnnouncements(
      {required int userId});
  Future<Either<String, AnnouncementDetailsResponse>> getAnnouncementDetails(
      {required int id});
}

class MasjidRepositoryImpl extends MasjidRepository {
  final NetworkService _networkService;

  MasjidRepositoryImpl(this._networkService);

  @override
  Future<Either<String, MasjidListResponse>> getMasjedsList({
    required int page,
    required String city,
    required String province,
    required String country,
  }) async {
    try {
      final response = await _networkService.get(
        "masjids?province=$province&city=$city&per_page=10&page=$page&country=$country",
      );
      MasjidListResponse res = MasjidListResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, MasjidDetailsResponse>> getMasjedsDetails(
      {required int id}) async {
    final userId = await UserIdUtil.getUserIdFromMemory();
    try {
      final response = await _networkService.get(
        userId.isNotEmpty
            ? "masjid/$id?user_id=${await UserIdUtil.getUserIdFromMemory()}"
            : "masjid/$id",
      );
      MasjidDetailsResponse res = MasjidDetailsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FollowMasjedResponse>> followMasjed(
      {required int masjedId}) async {
    final userId = await UserIdUtil.getUserIdFromMemory();
    try {
      final response = await _networkService
          .post("follow?user_id=$userId&masjid_id=$masjedId", {});
      FollowMasjedResponse res = FollowMasjedResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FollowMasjedResponse>> unfollowMasjed(
      {required int masjedId}) async {
    final userId = await UserIdUtil.getUserIdFromMemory();
    try {
      final response = await _networkService
          .post("unfollow?user_id=$userId&masjid_id=$masjedId", {});
      FollowMasjedResponse res = FollowMasjedResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LocationsModels>> getLocations() async {
    try {
      final response = await _networkService.get(
        "locations",
      );
      LocationsModels res = LocationsModels.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserMasjedsModel>> getUserMasjedsList() async {
    final userId = await UserIdUtil.getUserIdFromMemory();
    try {
      final response = await _networkService.get(
        "followers/$userId",
      );
      UserMasjedsModel res = UserMasjedsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CitiesResponseModel>> getCities(
      {required int countryId}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "locations/cities/$countryId?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      CitiesResponseModel res = CitiesResponseModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, CountriesResponseModel>> getCountries() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "locations/countries?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      CountriesResponseModel res =
          CountriesResponseModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ProvincesResponseModel>> getProvinces(
      {required int cityId}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "locations/provinces/$cityId?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      ProvincesResponseModel res =
          ProvincesResponseModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AnnouncementsResponse>> getAnnouncements(
      {required int userId}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "announcements?lang=${localizationCacheHelper.getLanguageCode()}&user=$userId",
      );
      AnnouncementsResponse res =
          AnnouncementsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AnnouncementDetailsResponse>> getAnnouncementDetails(
      {required int id}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "announcement/$id?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      AnnouncementDetailsResponse res =
          AnnouncementDetailsResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
