import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/token_util.dart';

import '../../../../core/util/network_service.dart';

import '../models/follow_masjed_model.dart';
import '../models/location_model.dart';
import '../models/masjed_details_model.dart';
import '../models/masjed_list_model.dart';
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
  Future<Either<String, UserMasjedsModel>> getUserMasjedsList();
  Future<Either<String, FollowMasjedResponse>> followMasjed({
    required int masjedId,
  });
  Future<Either<String, FollowMasjedResponse>> unfollowMasjed({
    required int masjedId,
  });
  Future<Either<String, LocationsModels>> getLocations();
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
}
