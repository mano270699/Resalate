import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

import '../models/live_feed_details.dart';

abstract class LiveFeedRepository {
  Future<Either<String, LiveFeedDetailsModel>> getLiveFeedDetails(
      {required int id});
}

class LiveFeedRepositoryImpl extends LiveFeedRepository {
  final NetworkService _networkService;

  LiveFeedRepositoryImpl(this._networkService);

  @override
  Future<Either<String, LiveFeedDetailsModel>> getLiveFeedDetails(
      {required int id}) async {
    try {
      final response = await _networkService.get(
        "live-feed/$id",
      );
      LiveFeedDetailsModel res = LiveFeedDetailsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
