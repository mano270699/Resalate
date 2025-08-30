import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/src/home/data/models/funerial_model.dart';
import 'package:resalate/src/home/data/models/lessons_model.dart';
import 'package:resalate/src/home/data/models/live_model.dart';
import 'package:resalate/src/home/data/repository/home_repository.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/donation_model.dart';
import '../data/models/home_data_model.dart';

class HomeViewModel {
  final HomeRepositoryImpl homeRepositoryImpl;

  HomeViewModel(this.homeRepositoryImpl);

  GenericCubit<HomeDataModel> homeResponse = GenericCubit(HomeDataModel());

  Future<void> getHomeData() async {
    homeResponse.onLoadingState();
    try {
      Either<String, HomeDataModel> response =
          await homeRepositoryImpl.getHomeData();

      response.fold(
        (failure) {
          homeResponse.onErrorState(Failure(failure));
        },
        (user) async {
          homeResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      homeResponse.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<DonationsResponse> donationResponse =
      GenericCubit(DonationsResponse());
  GenericCubit<LiveFeedsResponse> allfeedLiveRes =
      GenericCubit(LiveFeedsResponse());

  Future<void> getDonationsData() async {
    donationResponse.onLoadingState();
    try {
      Either<String, DonationsResponse> response =
          await homeRepositoryImpl.getDonationData();

      response.fold(
        (failure) {
          donationResponse.onErrorState(Failure(failure));
        },
        (user) async {
          donationResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      donationResponse.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<LiveFeedsResponse> liveResponse =
      GenericCubit(LiveFeedsResponse());

  Future<void> getLiveFeedData() async {
    liveResponse.onLoadingState();
    try {
      Either<String, LiveFeedsResponse> response =
          await homeRepositoryImpl.getLiveFeed(page: 1);

      response.fold(
        (failure) {
          liveResponse.onErrorState(Failure(failure));
        },
        (user) async {
          liveResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      liveResponse.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<LessonsResponse> lessonsResponse =
      GenericCubit(LessonsResponse());

  Future<void> getLessonsData() async {
    lessonsResponse.onLoadingState();
    try {
      Either<String, LessonsResponse> response =
          await homeRepositoryImpl.getLessons(page: 1);

      response.fold(
        (failure) {
          lessonsResponse.onErrorState(Failure(failure));
        },
        (user) async {
          lessonsResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      lessonsResponse.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<FuneralsResponse> funeralsResponse =
      GenericCubit(FuneralsResponse());

  Future<void> getFuneralsData() async {
    funeralsResponse.onLoadingState();
    try {
      Either<String, FuneralsResponse> response =
          await homeRepositoryImpl.getFuneralsData(page: 1);

      response.fold(
        (failure) {
          funeralsResponse.onErrorState(Failure(failure));
        },
        (user) async {
          funeralsResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      funeralsResponse.onErrorState(Failure('$e'));
    }
  }

  int _currentPage = 1;
  bool _isLoadingMoreFeed = false;

  Future<void> getAllFeedLive(int page, {bool isLoadMore = false}) async {
    if (_isLoadingMoreFeed) return; // prevent multiple requests
    if (isLoadMore) _isLoadingMoreFeed = true;
    if (!isLoadMore) {
      allfeedLiveRes.onLoadingState();
    }

    try {
      final response = await homeRepositoryImpl.getLiveFeed(page: page);

      response.fold(
        (failure) {
          allfeedLiveRes.onErrorState(Failure(failure));
        },
        (user) async {
          if (isLoadMore) {
            // Append to existing list
            final currentData = allfeedLiveRes.state.data;
            final updatedPosts = [...?currentData.posts, ...?user.posts];
            allfeedLiveRes.onUpdateData(
              LiveFeedsResponse(
                status: user.status,
                pagination: user.pagination,
                posts: updatedPosts,
              ),
            );
          } else {
            allfeedLiveRes.onUpdateData(user);
          }

          _currentPage = page;
        },
      );
    } on Failure catch (e, s) {
      debugPrint("Error in pagination: $s");
      allfeedLiveRes.onErrorState(Failure('$e'));
    }

    _isLoadingMoreFeed = false;
  }

  void loadNextPage() {
    final pagination = allfeedLiveRes.state.data.pagination;
    if (pagination != null &&
        pagination.currentPage! < pagination.totalPages!) {
      getAllFeedLive(_currentPage + 1, isLoadMore: true);
    }
  }

  bool get hasMorePages {
    final pagination = allfeedLiveRes.state.data.pagination;
    if (pagination == null) return false;
    return pagination.currentPage! < pagination.totalPages!;
  }

  int _currentPageLesson = 1;
  bool _isLoadingMoreLesson = false;
  GenericCubit<LessonsResponse> allLessonsRes = GenericCubit(LessonsResponse());
  Future<void> getAllLesson(int page, {bool isLoadMore = false}) async {
    if (_isLoadingMoreLesson) return; // prevent multiple requests
    if (isLoadMore) _isLoadingMoreLesson = true;
    if (!isLoadMore) {
      allLessonsRes.onLoadingState();
    }

    try {
      final response = await homeRepositoryImpl.getLessons(page: page);

      response.fold(
        (failure) {
          allLessonsRes.onErrorState(Failure(failure));
        },
        (user) async {
          if (isLoadMore) {
            // Append to existing list
            final currentData = allLessonsRes.state.data;
            final updatedPosts = [...?currentData.lessons, ...?user.lessons];
            allLessonsRes.onUpdateData(
              LessonsResponse(
                status: user.status,
                pagination: user.pagination,
                lessons: updatedPosts,
              ),
            );
          } else {
            allLessonsRes.onUpdateData(user);
          }

          _currentPageLesson = page;
        },
      );
    } on Failure catch (e, s) {
      debugPrint("Error in pagination: $s");
      allLessonsRes.onErrorState(Failure('$e'));
    }

    _isLoadingMoreLesson = false;
  }

  void loadNextPageLesson() {
    final pagination = allLessonsRes.state.data.pagination;
    if (pagination != null &&
        pagination.currentPage! < pagination.totalPages!) {
      getAllFeedLive(_currentPageLesson + 1, isLoadMore: true);
    }
  }

  bool get hasMorePagesLesson {
    final pagination = allLessonsRes.state.data.pagination;
    if (pagination == null) return false;
    return pagination.currentPage! < pagination.totalPages!;
  }
  //---------------------------AllFunerals

  int _currentPageFunerals = 1;
  bool _isLoadingMoreFunerals = false;
  GenericCubit<FuneralsResponse> allFuneralsRes =
      GenericCubit(FuneralsResponse());
  Future<void> getAllFunerals(int page, {bool isLoadMore = false}) async {
    if (_isLoadingMoreFunerals) return; // prevent multiple requests
    if (isLoadMore) _isLoadingMoreFunerals = true;
    if (!isLoadMore) {
      allFuneralsRes.onLoadingState();
    }

    try {
      final response = await homeRepositoryImpl.getFuneralsData(page: page);

      response.fold(
        (failure) {
          allFuneralsRes.onErrorState(Failure(failure));
        },
        (user) async {
          if (isLoadMore) {
            // Append to existing list
            final currentData = allFuneralsRes.state.data;
            final updatedPosts = [...?currentData.posts, ...?user.posts];
            allFuneralsRes.onUpdateData(
              FuneralsResponse(
                status: user.status,
                pagination: user.pagination,
                posts: updatedPosts,
              ),
            );
          } else {
            allFuneralsRes.onUpdateData(user);
          }

          _currentPageFunerals = page;
        },
      );
    } on Failure catch (e, s) {
      debugPrint("Error in pagination: $s");
      allFuneralsRes.onErrorState(Failure('$e'));
    }

    _isLoadingMoreFunerals = false;
  }

  void loadNextPageFunerals() {
    final pagination = allFuneralsRes.state.data.pagination;
    if (pagination != null &&
        pagination.currentPage! < pagination.totalPages!) {
      getAllFeedLive(_currentPageFunerals + 1, isLoadMore: true);
    }
  }

  bool get hasMorePagesFunerals {
    final pagination = allFuneralsRes.state.data.pagination;
    if (pagination == null) return false;
    return pagination.currentPage! < pagination.totalPages!;
  }
}
