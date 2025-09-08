import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/blocs/generic_cubit/generic_cubit.dart';
import 'package:resalate/src/from_mosque_to_mosque/data/models/masjed_to_masjed_detais_model.dart';
import 'package:resalate/src/from_mosque_to_mosque/data/models/masjed_to_masjed_model.dart';
import '../../../core/common/models/failure.dart';
import '../data/repository/masjed_to_masjed_repository.dart';

class MasjedToMasjedViewModel {
  final MasjedToMasjedRepositoryImpl masjedRepositoryImpl;

  MasjedToMasjedViewModel(this.masjedRepositoryImpl);

  GenericCubit<MasjedToMasjedModel> masjedToMasjedRes =
      GenericCubit(MasjedToMasjedModel());
  GenericCubit<MasjedToMasjedDetailsModel> masjedToMasjedDetailsRes =
      GenericCubit(MasjedToMasjedDetailsModel());

  Future<void> getMasjedToMasjedDetails({required int id}) async {
    masjedToMasjedDetailsRes.onLoadingState();
    try {
      Either<String, MasjedToMasjedDetailsModel> response =
          await masjedRepositoryImpl.getMasjedToMasjedDetails(id: id);

      response.fold(
        (failure) {
          masjedToMasjedDetailsRes.onErrorState(Failure(failure));
        },
        (res) async {
          masjedToMasjedDetailsRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      masjedToMasjedDetailsRes.onErrorState(Failure('$e'));
    }
  }

  int _currentPage = 1;
  bool _isLoadingMore = false;
  Future<void> getMasjedToMasjed(
      {required int page, bool isLoadMore = false}) async {
    if (_isLoadingMore) return; // prevent multiple requests
    if (isLoadMore) _isLoadingMore = true;
    if (!isLoadMore) {
      masjedToMasjedRes.onLoadingState();
    }

    try {
      final response = await masjedRepositoryImpl.getMasjedToMasjed(page: page);

      response.fold(
        (failure) => masjedToMasjedRes.onErrorState(Failure(failure)),
        (res) {
          if (isLoadMore) {
            final currentData = masjedToMasjedRes.state.data;
            final updatedPosts = [...?currentData.posts, ...?res.posts];
            masjedToMasjedRes.onUpdateData(
              MasjedToMasjedModel(
                status: res.status,
                pagination: res.pagination,
                posts: updatedPosts,
              ),
            );
          } else {
            masjedToMasjedRes.onUpdateData(res);
          }

          _currentPage = page;
        },
      );
    } on Failure catch (e, s) {
      debugPrint("Get Error: $s");
      masjedToMasjedRes.onErrorState(Failure('$e'));
    }
    _isLoadingMore = false;
  }

  void loadNextPage() {
    final pagination = masjedToMasjedRes.state.data.pagination;
    if (pagination != null &&
        pagination.currentPage! < pagination.totalPages!) {
      getMasjedToMasjed(page: _currentPage + 1, isLoadMore: true);
    }
  }

  bool get hasMorePages {
    final pagination = masjedToMasjedRes.state.data.pagination;
    if (pagination == null) return false;
    return pagination.currentPage! < pagination.totalPages!;
  }
}
