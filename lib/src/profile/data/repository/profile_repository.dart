import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:resalate/core/common/models/error_model.dart';
import 'package:resalate/core/common/models/failure.dart';
import 'package:resalate/core/util/token_util.dart';
import 'package:resalate/src/profile/data/models/profile_model.dart';
import 'package:resalate/src/profile/data/models/update_user_data.dart';
import 'package:http_parser/http_parser.dart'; // for MediaType

import '../../../../core/common/error/error_handler.dart';
import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';
import '../../../home/data/models/home_data_model.dart';
import '../models/sponser_model.dart';

abstract class ProfileRepository {
  Future<Either<String, ProfileModelResponse>> getProfileData();
  Future<Either<String, SponserModel>> addSponser({
    required String name,
    required String phone,
    required String message,
    required String email,
  });
  Future<Either<String, DefaultModel>> contactUs({
    required String name,
    required String phone,
    required String subject,
    required String message,
    required String email,
  });
  Future<Either<String, HomeDataModel>> getAppOption();
  Future<Either<String, UpdateUserResponse>> updateProfile({
    required String name,
    required String phone,
    required String email,
    File? filePath,
  });
  Future<Either<String, DefaultModel>> logout();
  Future<Either<String, DefaultModel>> deleteAccount();
}

class ProfileRepositoryImpl extends ProfileRepository {
  final NetworkService _networkService;

  ProfileRepositoryImpl(this._networkService);

  @override
  Future<Either<String, ProfileModelResponse>> getProfileData() async {
    try {
      final token = await TokenUtil.getTokenFromMemory();
      final response = await _networkService
          .get("user-info", headers: {"Authorization": "Bearer $token"});
      ProfileModelResponse res = ProfileModelResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UpdateUserResponse>> updateProfile({
    required String name,
    required String phone,
    required String email,
    File? filePath,
  }) async {
    try {
      // Initialize FormData
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
      });

      // Attach image file if available
      if (filePath != null && filePath.path.isNotEmpty) {
        debugPrint("Uploading image");
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              filePath.path,
              filename: filePath.path.split('/').last,
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      // Send request
      final response = await _networkService.post(
        "update-user?lang=${localizationCacheHelper.getLanguageCode()}",
        formData,
        headers: {
          "Authorization": 'Bearer ${await TokenUtil.getTokenFromMemory()}',
        },
      );

      // Check for 400 status code *after* a successful network request (no exception)
      if (response.statusCode == 400) {
        // Handle 400 error specifically
        if (response.data != null && response.data is Map<String, dynamic>) {
          // Extract error message from response
          final errorMessage = response.data['error'] ??
              'Invalid input data.'; // Adjust key if necessary

          return Left(errorMessage);
        } else {
          return const Left(
              'Invalid input data. Please check your information.');
        }
      }

      // Parse response if status code is not 400
      UpdateUserResponse userModel = UpdateUserResponse.fromJson(response.data);
      return Right(userModel);
    } on Failure catch (e) {
      return Left(e.message ?? "");

      // Display the error message to the user
      // _showErrorDialog(e.message);
    } on DioException catch (e) {
      debugPrint("DioException::${e.error}");
      // Handle DioException (network errors, timeouts, etc.)
      return Left(ResponseError.getMessage(e));
    } catch (e) {
      debugPrint("catch::$e");

      // Handle other exceptions
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, SponserModel>> addSponser(
      {required String name,
      required String phone,
      required String message,
      required String email}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "sponsor-request?lang=${localizationCacheHelper.getLanguageCode()}",
          {"name": name, "email": email, "phone": phone, "message": message});
      SponserModel res = SponserModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, HomeDataModel>> getAppOption() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "app-options?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      HomeDataModel res = HomeDataModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DefaultModel>> deleteAccount() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "delete-account?lang=${localizationCacheHelper.getLanguageCode()}",
          headers: {
            "Authorization": "Bearer ${await TokenUtil.getTokenFromMemory()}"
          },
          {});
      DefaultModel res = DefaultModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DefaultModel>> logout() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
        "logout?lang=${localizationCacheHelper.getLanguageCode()}",
        {},
        headers: {
          "Authorization": "Bearer ${await TokenUtil.getTokenFromMemory()}"
        },
      );
      DefaultModel res = DefaultModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DefaultModel>> contactUs(
      {required String name,
      required String phone,
      required String subject,
      required String message,
      required String email}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService
          .post("contact?lang=${localizationCacheHelper.getLanguageCode()}", {
        "name": name,
        "email": email,
        "phone": phone,
        "message": message,
        "subject": subject
      });
      DefaultModel res = DefaultModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
