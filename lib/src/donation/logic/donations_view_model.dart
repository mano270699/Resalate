import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/donation_details_model.dart';
import '../data/models/donation_model.dart';
import '../data/repository/donetatio_repository.dart';

class DonationsViewModel {
  final DonetatioRepositoryImpl donetatioRepositoryImpl;

  DonationsViewModel({required this.donetatioRepositoryImpl});

  GenericCubit<DonationsResponse> donationResponse =
      GenericCubit(DonationsResponse(posts: []));

  int _currentPage = 1;
  bool _isLoadingMore = false;

  Future<void> getDonationsData(int page, {bool isLoadMore = false}) async {
    if (_isLoadingMore) return; // prevent multiple requests
    if (isLoadMore) _isLoadingMore = true;
    if (!isLoadMore) {
      donationResponse.onLoadingState();
    }

    try {
      final response =
          await donetatioRepositoryImpl.getDonationData(page: page);

      response.fold(
        (failure) {
          donationResponse.onErrorState(Failure(failure));
        },
        (user) async {
          if (isLoadMore) {
            // Append to existing list
            final currentData = donationResponse.state.data;
            final updatedPosts = [...?currentData.posts, ...?user.posts];
            donationResponse.onUpdateData(
              DonationsResponse(
                status: user.status,
                pagination: user.pagination,
                posts: updatedPosts,
              ),
            );
          } else {
            donationResponse.onUpdateData(user);
          }

          _currentPage = page;
        },
      );
    } on Failure catch (e, s) {
      debugPrint("Error in pagination: $s");
      donationResponse.onErrorState(Failure('$e'));
    }

    _isLoadingMore = false;
  }

  void loadNextPage() {
    final pagination = donationResponse.state.data.pagination;
    if (pagination != null &&
        pagination.currentPage! < pagination.totalPages!) {
      getDonationsData(_currentPage + 1, isLoadMore: true);
    }
  }

  bool get hasMorePages {
    final pagination = donationResponse.state.data.pagination;
    if (pagination == null) return false;
    return pagination.currentPage! < pagination.totalPages!;
  }

  GenericCubit<DonationsDetailsResponse> donationDetailsResponse =
      GenericCubit(DonationsDetailsResponse());
  Future<void> getDonationsDetails(int id) async {
    donationDetailsResponse.onLoadingState();
    try {
      Either<String, DonationsDetailsResponse> response =
          await donetatioRepositoryImpl.getDonationDetails(id: id);

      response.fold(
        (failure) {
          donationDetailsResponse.onErrorState(Failure(failure));
        },
        (user) async {
          donationDetailsResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      donationDetailsResponse.onErrorState(Failure('$e'));
    }
  }
}
