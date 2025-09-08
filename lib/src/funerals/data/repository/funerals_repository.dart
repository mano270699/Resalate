import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/network_service.dart';

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
      final response = await _networkService.get(
        "funerals/$id",
      );
      FuneralsDetailsModel res = FuneralsDetailsModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
