import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/lesson_details.dart';
import '../data/repository/lesson_repository.dart';

class LessonViewModel {
  final LessonsRepositoryImpl _lessonRepositoryImpl;

  LessonViewModel(this._lessonRepositoryImpl);

  GenericCubit<LessonDetailsModel> lessonDetailsRes =
      GenericCubit(LessonDetailsModel());
  Future<void> getLessonDetails({required int id}) async {
    lessonDetailsRes.onLoadingState();
    try {
      Either<String, LessonDetailsModel> response =
          await _lessonRepositoryImpl.getLessonDetails(id: id);

      response.fold(
        (failure) {
          lessonDetailsRes.onErrorState(Failure(failure));
        },
        (res) async {
          lessonDetailsRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      lessonDetailsRes.onErrorState(Failure('$e'));
    }
  }
}
