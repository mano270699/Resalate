import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/util/localization/app_localizations.dart';
import 'package:resalate/core/util/token_util.dart';
import 'package:resalate/src/my_mosque/data/models/masjed_list_model.dart';
import 'package:resalate/src/my_mosque/data/repository/masjed_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/failure.dart';
import '../data/models/follow_masjed_model.dart';
import '../data/models/location_model.dart';
import '../data/models/masjed_details_model.dart';
import '../data/models/user_masjeds_model.dart';

class MasjedViewModel {
  final MasjidRepositoryImpl masjidRepositoryImpl;

  MasjedViewModel(this.masjidRepositoryImpl);
  GenericCubit<MasjidListResponse> masjidResponse =
      GenericCubit(MasjidListResponse());

  int _currentPage = 1;
  bool _isLoadingMore = false;

  Future<void> getMasjedsData(int page,
      {bool isLoadMore = false,
      String? country,
      String? province,
      String? city}) async {
    if (_isLoadingMore) return;
    if (isLoadMore) _isLoadingMore = true;
    if (!isLoadMore) {
      masjidResponse.onLoadingState();
    }

    try {
      final response = await masjidRepositoryImpl.getMasjedsList(
          page: page,
          country: country ?? "",
          city: city ?? "",
          province: province ?? "");

      response.fold(
        (failure) {
          masjidResponse.onErrorState(Failure(failure));
        },
        (data) {
          if (isLoadMore) {
            final currentData = masjidResponse.state.data;
            final updatedMasjids = [...?currentData.masjids, ...?data.masjids];
            masjidResponse.onUpdateData(
              MasjidListResponse(
                status: data.status,
                currentPage: data.currentPage,
                perPage: data.perPage,
                total: data.total,
                totalPages: data.totalPages,
                masjids: updatedMasjids,
              ),
            );
          } else {
            masjidResponse.onUpdateData(data);
          }
          _currentPage = page;
        },
      );
    } on Failure catch (e, s) {
      debugPrint("Masjid pagination error: $s");
      masjidResponse.onErrorState(Failure('$e'));
    }

    _isLoadingMore = false;
  }

  void loadNextPage() {
    final currentData = masjidResponse.state.data;
    if ((currentData.currentPage ?? 0) < (currentData.totalPages ?? 0)) {
      getMasjedsData(_currentPage + 1, isLoadMore: true);
    }
  }

  bool get hasMorePages {
    final pagination = masjidResponse.state.data;
    return (pagination.currentPage ?? 0) < (pagination.totalPages ?? 0);
  }

  Future<void> filterMasjeds({
    String? country,
    String? province,
    String? city,
  }) async {
    _currentPage = 1;
    await getMasjedsData(
      1,
      country: country,
      province: province,
      city: city,
    );
  }

  GenericCubit<bool> isUserFollowMasjed = GenericCubit(false);
  GenericCubit<MasjidDetailsResponse> masjedDetailsRes =
      GenericCubit(MasjidDetailsResponse());
  Future<void> getMasjedsDetails({required int id}) async {
    masjedDetailsRes.onLoadingState();
    try {
      Either<String, MasjidDetailsResponse> response =
          await masjidRepositoryImpl.getMasjedsDetails(id: id);

      response.fold(
        (failure) {
          masjedDetailsRes.onErrorState(Failure(failure));
        },
        (res) async {
          final htmlString = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body, html {
          margin: 0;
          padding: 0;
          height: 100%;
        }
        iframe {
          width: 100%;
          height: 100%;
          border: 0;
        }
      </style>
    </head>
    <body>
      <iframe src="${res.masjid!.location}" allowfullscreen="" loading="lazy"></iframe>
    </body>
    </html>
    ''';
          controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadHtmlString(htmlString);
          controllerCubit.onUpdateData(controller);
          isUserFollowMasjed.onUpdateData(res.masjid!.isFollowing ?? false);
          masjedDetailsRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      masjedDetailsRes.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<WebViewController> controllerCubit =
      GenericCubit(WebViewController());
  late final WebViewController controller;

  GenericCubit<FollowMasjedResponse> followActionRes =
      GenericCubit(FollowMasjedResponse());
  Locations? selectedCountry;
  States? selectedProvince;
  Cities? selectedCity;
  final GenericCubit<LocationsModels> getLocationsListRes =
      GenericCubit(LocationsModels());
  Future<void> getLocationsList() async {
    getLocationsListRes.onLoadingState();
    try {
      final response = await masjidRepositoryImpl.getLocations();

      response.fold(
        (failure) => getLocationsListRes.onErrorState(Failure(failure)),
        (res) {
          countriesList.onUpdateData(res.locations ?? []);
          getLocationsListRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("GetLocations Error: $s");
      getLocationsListRes.onErrorState(Failure('$e'));
    }
  }

  // --- Getters ---

  GenericCubit<List<Locations>> countriesList = GenericCubit([]);
  GenericCubit<List<States>> provincesList = GenericCubit([]);
  GenericCubit<List<Cities>> citiesList = GenericCubit([]);
  List<Locations> get countries =>
      getLocationsListRes.state.data.locations ?? [];

  List<States> get provinces => selectedCountry?.states ?? [];

  List<Cities> get cities => selectedProvince?.cities ?? [];

  // --- Selection Handlers ---
  void selectCountry(Locations? country) {
    selectedCountry = country;
    selectedProvince = null;
    selectedCity = null;
    provincesList.onUpdateData(country?.states ?? []);
    citiesList.onUpdateData([]); // reset cities
  }

  void selectProvince(States? province) {
    selectedProvince = province;
    selectedCity = null;
    citiesList.onUpdateData(province?.cities ?? []);
  }

  void selectCity(Cities? city) {
    selectedCity = city;
  }

  // --- Actions ---
  void resetSelection() {
    selectedCountry = null;
    selectedProvince = null;
    selectedCity = null;
  }

  void applySelection() {
    // Trigger your filter API or business logic here
    filterMasjeds(
      country: selectedCountry?.country,
      province: selectedProvince?.state,
      city: selectedCity?.name,
    );
  }

  Future<void> followMasjed(BuildContext context,
      {required int masjedId}) async {
    followActionRes.onLoadingState();
    final token = await TokenUtil.getTokenFromMemory();
    if (token.isNotEmpty) {
      try {
        Either<String, FollowMasjedResponse> response =
            await masjidRepositoryImpl.followMasjed(masjedId: masjedId);

        response.fold(
          (failure) {
            followActionRes.onErrorState(Failure(failure));
          },
          (res) async {
            isUserFollowMasjed.onUpdateData(true);
            followActionRes.onUpdateData(res);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        followActionRes.onErrorState(Failure('$e'));
      }
    } else {
      if (context.mounted) {
        followActionRes.onErrorState(Failure(AppLocalizations.of(context)!
            .translate("you_must_login_to_follow_masjed")));
      }
    }
  }

  Future<void> unfollowMasjed(BuildContext context,
      {required int masjedId}) async {
    followActionRes.onLoadingState();
    final token = await TokenUtil.getTokenFromMemory();
    if (token.isNotEmpty) {
      try {
        Either<String, FollowMasjedResponse> response =
            await masjidRepositoryImpl.unfollowMasjed(masjedId: masjedId);

        response.fold(
          (failure) {
            followActionRes.onErrorState(Failure(failure));
          },
          (res) async {
            isUserFollowMasjed.onUpdateData(false);
            followActionRes.onUpdateData(res);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        followActionRes.onErrorState(Failure('$e'));
      }
    } else {
      if (context.mounted) {
        followActionRes.onErrorState(Failure(AppLocalizations.of(context)!
            .translate("you_must_login_to_follow_masjed")));
      }
    }
  }

  GenericCubit<UserMasjedsModel> userMasjidResponse =
      GenericCubit(UserMasjedsModel());

  Future<void> getUserMasjeds() async {
    userMasjidResponse.onLoadingState();
    try {
      Either<String, UserMasjedsModel> response =
          await masjidRepositoryImpl.getUserMasjedsList();

      response.fold(
        (failure) {
          userMasjidResponse.onErrorState(Failure(failure));
        },
        (res) async {
          userMasjidResponse.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      userMasjidResponse.onErrorState(Failure('$e'));
    }
  }
}
