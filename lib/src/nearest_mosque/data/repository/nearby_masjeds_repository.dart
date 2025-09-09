import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

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
      final response = await _networkService
          .get("nearby-masjids?lat=30.05&lng=31.25&radius=2000000000"
              // "nearby-masjids?lat=$lat&lng=$lng&radius=$radius",
              );
      NearbyMasjidsModel res = NearbyMasjidsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
