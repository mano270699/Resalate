import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:flutter/foundation.dart';
import 'package:resalate/src/Auth/data/models/login_model.dart';

import '../../../../core/common/error/error_handler.dart';
import '../../../../core/common/models/error_model.dart';
import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';

import '../../../../core/util/token_util.dart';
import '../models/fcm_model.dart';
import '../models/register_model.dart';
import '../models/reset_password_model.dart';

abstract class AuthRepository {
  Future<Either<String, RegisterModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });
  Future<Either<String, LoginResponse>> login({
    required String userNameEmail,
    required String password,
  });
  Future<Either<ErrorModel, LoginResponse>> googleLogin({
    required String googleToken,
  });
  Future<Either<ErrorModel, SocialLoginResponse>> appleLogin({
    required String appleToken,
  });
  Future<Either<String, DefaultModel>> forgetPassword({required String email});
  Future<Either<String, DefaultModel>> verifyOtp(
      {required String email, required String code});
  Future<Either<String, ResetPasswordResponse>> resetPassword(
      {required String email,
      required String code,
      required String password,
      required String confirmPassword});

  Future<Either<String, FCMTokenModel>> updateFCMToken();
}

class AuthRepositoryImpl extends AuthRepository {
  final NetworkService _networkService;

  AuthRepositoryImpl(this._networkService);

  @override
  Future<Either<String, RegisterModel>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return Left("Passwords do not match.");
    }

    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "register?lang=${localizationCacheHelper.getLanguageCode()}",
          jsonEncode({
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
            "password2": confirmPassword
          }));

      if (kDebugMode) {
        // Use kDebugMode for debugPrint checks.
        print("statusCode::${response.statusCode} ");
      }

      // Assuming response has a status code and data field

      RegisterModel registerModel = RegisterModel.fromJson(response.data);
      return Right(registerModel);
    } catch (e, t) {
      if (kDebugMode) {
        print("catch::${e.toString()} ,,, trace $t");
      }

      // Catch any exception and return it as ErrorModel
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LoginResponse>> login(
      {required String userNameEmail, required String password}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "login?username=$userNameEmail&password=$password&lang=${localizationCacheHelper.getLanguageCode()}",
          {});

      debugPrint("response.statusCode::${response.statusCode}");
      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        if (kDebugMode) {
          print("Data::${response.data}");
        }

        // Check if response.data is already an ErrorModel or needs to be converted
        ErrorModel errorModel;
        if (response.data is Map<String, dynamic>) {
          // Response data is a map, parse as ErrorModel
          errorModel = ErrorModel.fromJson(response.data);
        } else {
          // Response data is not a map, create an ErrorModel with a default message
          errorModel =
              ErrorModel(message: response.data.toString(), status: 'Error');
        }

        return Left(errorModel.message);
      }
    } catch (e, t) {
      debugPrint("Error::$e--- trace::$t}");

      // Catch any exception and return it as ErrorModel
      return Left(e.toString());
      // return Left(
      //     ErrorModel(message: ResponseError.getMessage(e), status: "Error"));
    }
  }

  @override
  Future<Either<ErrorModel, LoginResponse>> googleLogin(
      {required String googleToken}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();

      final response = await _networkService.post(
          "google-login?lang=${localizationCacheHelper.getLanguageCode()}", {
        "id_token": googleToken,
      });
      // Assuming response has a status code and data field
      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        // Convert error response to ErrorModel if status is not 200
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        return Left(ResponseError.getMessage(errorModel.message));
      }
    } catch (e, t) {
      debugPrint("Error::$e--- trace::$t}");
      // Catch any exception and return it as ErrorModel
      return Left(ErrorModel(message: e.toString(), status: "Error"));
    }
  }

  @override
  Future<Either<String, DefaultModel>> forgetPassword(
      {required String email}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "forget-password?email=$email&lang=${localizationCacheHelper.getLanguageCode()}",
          {});
      DefaultModel res = DefaultModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorModel, SocialLoginResponse>> appleLogin(
      {required String appleToken}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();

      final response = await _networkService.post(
          "apple-login-register?lang=${localizationCacheHelper.getLanguageCode()}",
          {
            "apple_token": appleToken,
          });
      // Assuming response has a status code and data field
      if (response.statusCode == 200) {
        SocialLoginResponse loginResponse =
            SocialLoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        // Convert error response to ErrorModel if status is not 200
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        return Left(ResponseError.getMessage(errorModel.message));
      }
    } catch (e) {
      debugPrint("error::$e");
      // Catch any exception and return it as ErrorModel
      return Left(ErrorModel(message: e.toString(), status: "Error"));
    }
  }

  @override
  Future<Either<String, DefaultModel>> verifyOtp(
      {required String email, required String code}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "verify-otp?email=$email&otp=$code&lang=${localizationCacheHelper.getLanguageCode()}",
          {});
      DefaultModel res = DefaultModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, ResetPasswordResponse>> resetPassword(
      {required String email,
      required String code,
      required String password,
      required String confirmPassword}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "reset-password?lang=${localizationCacheHelper.getLanguageCode()}", {
        "email": email,
        "otp": code,
        "password": password,
        "password2": confirmPassword
      });
      ResetPasswordResponse res = ResetPasswordResponse.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, FCMTokenModel>> updateFCMToken() async {
    try {
      final response = await _networkService.post(
          "save-fcm-token?user_id=${await UserIdUtil.getUserIdFromMemory()}&fcm_token=${await FCMTokenUtil.getFCMTokenFromMemory()}",
          {});
      FCMTokenModel res = FCMTokenModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(e.toString());
    }
  }
}
