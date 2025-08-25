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
          await homeRepositoryImpl.getLiveFeed();

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
          await homeRepositoryImpl.getLessons();

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
          await homeRepositoryImpl.getFuneralsData();

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
}
