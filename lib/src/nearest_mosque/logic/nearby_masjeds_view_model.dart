// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:resalate/core/common/models/failure.dart';
// import 'package:resalate/src/nearest_mosque/data/repository/nearby_masjeds_repository.dart';
// import '../../../core/blocs/generic_cubit/generic_cubit.dart';
// import '../data/models/nearby_masjids_model.dart';

// class NearbyMasjedsViewModel {
//   final NearbyMasjedsRepositoryImpl _nearbyMasjedsRepositoryImpl;

//   NearbyMasjedsViewModel(this._nearbyMasjedsRepositoryImpl);

//   final GenericCubit<List<Masjids>> getNearbyMasjedsRes = GenericCubit([]);

//   /// Get current location
//   Future<Position> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Failure("Location services are disabled");
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Failure("Location permissions are denied");
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       throw Failure("Location permissions are permanently denied");
//     }

//     return await Geolocator.getCurrentPosition(
//       locationSettings: LocationSettings(
//         accuracy: LocationAccuracy.best,
//       ),
//     );
//   }

//   GenericCubit<int> radiusFilter = GenericCubit(200);

//   /// Fetch masjids from repository
//   Future<void> getNearbyMasjedsList() async {
//     getNearbyMasjedsRes.onLoadingState();
//     try {
//       final position = await _getCurrentLocation();
//       final response = await _nearbyMasjedsRepositoryImpl.getNearbyMasjeds(
//         lat: position.latitude.toString(),
//         lng: position.longitude.toString(),
//         radius: radiusFilter.state.data.toString(),
//       );

//       response.fold(
//         (failure) => getNearbyMasjedsRes.onErrorState(Failure(failure)),
//         (res) {
//           // store list of masjids in cubit
//           getNearbyMasjedsRes.onUpdateData(res.masjids ?? []);
//         },
//       );
//     } on Failure catch (e, s) {
//       debugPrint("GetNearbyMasjeds Error: $s");
//       getNearbyMasjedsRes.onErrorState(Failure('$e'));
//     }
//   }

//   /// Local search filter by masjid name
//   void filterMasjeds(String query) {
//     final currentData = getNearbyMasjedsRes.state.data;
//     if (query.isEmpty) {
//       getNearbyMasjedsRes.onUpdateData(currentData);
//       return;
//     }

//     final filtered = currentData
//         .where((masjid) =>
//             masjid.name!.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     getNearbyMasjedsRes.onUpdateData(filtered);
//   }

//   changeRidusFilter(int value) {
//     radiusFilter.onUpdateData(value);
//     getNearbyMasjedsList();
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resalate/core/common/models/failure.dart';
import 'package:resalate/core/util/localization/app_localizations.dart';
import 'package:resalate/src/nearest_mosque/data/repository/nearby_masjeds_repository.dart';
import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../data/models/nearby_masjids_model.dart';

class NearbyMasjedsViewModel {
  final NearbyMasjedsRepositoryImpl _nearbyMasjedsRepositoryImpl;

  NearbyMasjedsViewModel(this._nearbyMasjedsRepositoryImpl);

  final GenericCubit<List<Masjids>> getNearbyMasjedsRes = GenericCubit([]);

  /// Keep backup of the full list (for reset)
  List<Masjids> _defaultMasjids = [];

  /// Get current location
  Future<Position?> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        throw Failure(AppLocalizations.of(context)!
            .translate("Location_services_are_disabled"));
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          throw Failure(AppLocalizations.of(context)!
              .translate("Location_permissions_are_denied"));
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        throw Failure(AppLocalizations.of(context)!
            .translate("Location_permissions_are_permanently_denied"));
      }
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  GenericCubit<int> radiusFilter = GenericCubit(200);

  /// Fetch masjids from repository
  Future<void> getNearbyMasjedsList(BuildContext context) async {
    getNearbyMasjedsRes.onLoadingState();
    try {
      final position = await _getCurrentLocation(context);

      if (position == null) {
        if (context.mounted) {
          getNearbyMasjedsRes.onErrorState(Failure(AppLocalizations.of(context)!
              .translate("Could_not_get_location")));
        }
        return;
      }

      final response = await _nearbyMasjedsRepositoryImpl.getNearbyMasjeds(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
        radius: radiusFilter.state.data.toString(),
      );

      response.fold(
        (failure) => getNearbyMasjedsRes.onErrorState(Failure(failure)),
        (res) {
          final list = res.masjids ?? [];
          _defaultMasjids = list; // save backup
          getNearbyMasjedsRes.onUpdateData(list);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("GetNearbyMasjeds Error: $s");
      getNearbyMasjedsRes.onErrorState(Failure('$e'));
    }
  }

  /// Local search filter by masjid name
  void filterMasjeds(String query) {
    if (query.isEmpty) {
      resetMasjidsList();
      return;
    }

    final filtered = _defaultMasjids
        .where((masjid) =>
            (masjid.name ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();

    getNearbyMasjedsRes.onUpdateData(filtered);
  }

  /// Reset to full list
  void resetMasjidsList() {
    getNearbyMasjedsRes.onUpdateData(_defaultMasjids);
  }

  changeRidusFilter(int value, BuildContext context) {
    radiusFilter.onUpdateData(value);
    getNearbyMasjedsList(context);
  }
}
