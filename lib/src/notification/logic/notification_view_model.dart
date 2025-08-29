import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/notification_model.dart';
import '../data/repository/notification_repository.dart';

class NotificationViewModel {
  final NotificationRepositoryImpl notificationRepositoryImpl;

  NotificationViewModel(this.notificationRepositoryImpl);

  GenericCubit<NotificationModel> notifcationRes =
      GenericCubit(NotificationModel());

  Future<void> getNotifications() async {
    try {
      notifcationRes.onLoadingState();
      Either<String, NotificationModel> response =
          await notificationRepositoryImpl.getNotifications();

      response.fold(
        (failure) {
          notifcationRes.onErrorState(Failure(failure));
        },
        (res) async {
          notifcationRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      notifcationRes.onErrorState(Failure('$e'));
    }
  }
}
