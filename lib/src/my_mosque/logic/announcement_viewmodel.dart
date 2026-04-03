import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/announcement_model.dart';
import '../data/repository/masjed_repository.dart';

class AnnouncementViewModel {
  final MasjidRepositoryImpl _masjidRepositoryImpl;

  AnnouncementViewModel(this._masjidRepositoryImpl);

  GenericCubit<AnnouncementDetailsResponse> announcementDetailsRes =
      GenericCubit(AnnouncementDetailsResponse());

  Future<void> getAnnouncementDetails({required int id}) async {
    announcementDetailsRes.onLoadingState();
    try {
      Either<String, AnnouncementDetailsResponse> response =
          await _masjidRepositoryImpl.getAnnouncementDetails(id: id);

      response.fold(
        (failure) {
          announcementDetailsRes.onErrorState(Failure(failure));
        },
        (res) async {
          announcementDetailsRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("AnnouncementDetails Error: $s");
      announcementDetailsRes.onErrorState(Failure('$e'));
    }
  }
}
