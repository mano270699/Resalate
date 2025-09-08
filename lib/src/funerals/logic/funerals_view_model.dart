import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/funerals_details.dart';
import '../data/repository/funerals_repository.dart';

class FuneralsViewModel {
  final FuneralsRepositoryImpl _funeralRepositoryImpl;

  FuneralsViewModel(this._funeralRepositoryImpl);

  GenericCubit<FuneralsDetailsModel> funeralDetailsRes =
      GenericCubit(FuneralsDetailsModel());
  Future<void> getFuneralDetails({required int id}) async {
    funeralDetailsRes.onLoadingState();
    try {
      Either<String, FuneralsDetailsModel> response =
          await _funeralRepositoryImpl.getFuneralDetails(id: id);

      response.fold(
        (failure) {
          funeralDetailsRes.onErrorState(Failure(failure));
        },
        (res) async {
          funeralDetailsRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      funeralDetailsRes.onErrorState(Failure('$e'));
    }
  }
}
